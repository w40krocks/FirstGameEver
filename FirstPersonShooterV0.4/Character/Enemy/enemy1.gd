extends "res://Character/character.gd"

#------OutOfSceneStuff
@onready var Player = self.get_parent().get_parent().get_child(0)
@onready var World = self.get_parent().get_parent()
@onready var DeathSprite = load("res://Character/Enemy/CorpsePlaceholder.png")
@onready var Projectile = load("res://Weapons/projectile.tscn")
#------OutOfSceneStuff

#------InSceneStuff
@onready var Sprite = $Body
@onready var SpottedSignal = $Spotted
@onready var DetectionTimer =$DetectionTimer
@onready var AttackTimer = $AttackCooldown
@onready var ProjectileSpawner = $ProjectileSpawnLocation
@onready var ObstructionCheck = $ObstructionCheck
#------InSceneStuff

#------RotationalStuff
var SelfForward 
var PlayerVec : Vector2
var SelfVec : Vector2
var SelfToPlayer 
var nSelf 
var dotResult
var DotProductResult
#------RotationalStuff

#------SpriteStuff
var SpriteCoords : Vector2
#------SpriteStuff

#------LookoutStuff
var Distance : float
var isSpotted : bool
var PlayerPos : Vector3
var Counter
#------LookoutStuff

func _ready() -> void:
	Counter = 0
	Health = 100
	MaxHealth = Health
	SpriteCoords.x = 0
	MoveSpeed = 5
	
func _process(delta: float) -> void:
	if Health <= 0:
		_Death()
		
	#used to determine what angle of enemies the player is looking at
	DotProductResult = _RotationDistanceToEnemyFront(Player)
	
	#determines the difference in position between player and enemy
	Distance = self.position.distance_to(Player.position)
	
	
	#uses the dotproduct to determine what enemy sprite is shown
	_SpriteRotation(DotProductResult)
	
	
	#checks if the player has been spotted by the enemy
	if isSpotted == false:
		#if they havent been spotted check if they can be spotetd
		_isSpotted(_isPlayerInConeOfVision(_isPlayerInRange(Distance)))
	elif isSpotted == true:
		#if they have been spotted gets the player position and makes the enemy look at the player
		PlayerPos = Player.position
		self.look_at(PlayerPos)
		#if player is more than 5 untis away from the enemy enemy will move towards player
		if Distance > 5:
			var direction = (PlayerPos - position).normalized()
			position += direction * MoveSpeed * delta
		#checks if the attack timer is currently running, if not restarts the timer
		if AttackTimer.is_stopped() == true:
			AttackTimer.start()
		

func _physics_process(delta: float) -> void:
	#enforces gravity onto the enemy
	if not is_on_floor():
		velocity += get_gravity() * delta
		move_and_slide()



func _RotationDistanceToEnemyFront(OtherBody):
	#gets the front position of the enemy, in this cause -Z
	SelfForward = -self.transform.basis.z
	#gets the horizontal position of the player
	PlayerVec.x =(OtherBody.get_child(2).global_position.x)
	PlayerVec.y =(OtherBody.get_child(2).global_position.z)
	#gets the horizontal position of the enemy
	SelfVec.x =(self.global_position.x)
	SelfVec.y =(self.global_position.z)
	#determines the direction of the enemy to the okayer
	SelfToPlayer = SelfVec.direction_to(PlayerVec)
	
	#normalises the enemies forward position
	nSelf = Vector2(SelfForward.x, SelfForward.z).normalized()
	#gets the dot result (NOTE not entirely sure how this works, but the outcomes is it determines
	#the rotational distance from the enemies forward position)
	dotResult = SelfToPlayer.dot(nSelf)
	return(dotResult)
	
func _SpriteRotation(RotationalDistance):
	#show front sprite
	if RotationalDistance >= 0.75:
		SpriteCoords.y = 0 
	#show side sprite
	elif RotationalDistance < 0.75 and RotationalDistance > -0.75:
		SpriteCoords.y = 1
	#show back sprite
	elif RotationalDistance < -0.75:
		SpriteCoords.y = 2
	#sets sprite coords
	Sprite.frame_coords = SpriteCoords


func _isPlayerInRange(DistanceBetween):
	if DistanceBetween < 2:
		#will always be spotted
		return(1)
	elif DistanceBetween < 20:
		#check if player is infront of enemy
		return(2)
	else:
		#not spotted
		return(3)

func _isPlayerInConeOfVision(isInRange : int):
	match isInRange:
		#is super close to enemy
		1:
			return true
		#is within DetectionRange
		2:
			#if player is infront of enemy run obstruction check function
			if DotProductResult >0.75:
				return _isEnemyViewClear()
		#is not in range
		3:
			return false
	
func _isSpotted(SpottedStatus):
	if SpottedStatus == true:
		SpottedSignal.show()
		isSpotted = true
		DetectionTimer.start()
	else:
		SpottedSignal.hide()

func _isEnemyViewClear():
	#sets the obstruction ray casts target position to player position
	_ObstructionRaySet()
	#if the first thing the obstruction ray cast collides with is not the player enemy view is obstructed
	if ObstructionCheck.get_collider() != Player:
		return false
	else:
	#view is not obstructed
		return true

func _ObstructionRaySet():
	#sets target position to player position
	ObstructionCheck.target_position = Player.position - self.position
	if ObstructionCheck.rotation != ObstructionCheck.rotation - self.rotation:
		ObstructionCheck.rotation = Vector3(0,0,0) - self.rotation
	#removes all of the enemies position information as the raycast will inherit all position
	#information as it is the enemies child

func _on_detection_timer_timeout() -> void:
	#if the timer stops, it means that the enemy has lost sight of the player
	#so the player is no longer spotted and it will stop attacking
	isSpotted = false
	AttackTimer.stop()

func _Death():
	#sets all the sprite information of the corpse sprite
	var CorpseSprite = Sprite3D.new()
	CorpseSprite.texture = DeathSprite
	CorpseSprite.position = self.position
	#lowers the sprite so it appears on the ground
	CorpseSprite.position.y = self.position.y -0.75
	CorpseSprite.rotation = self.rotation
	#adds the sprite as a child of the world
	World.add_child(CorpseSprite)
	#deletes enemy from scene
	queue_free()


func _on_attack_cooldown_timeout() -> void:
	#creates instance of the projectile scene
	var test = Projectile.instantiate()
	test.position = ProjectileSpawner.global_position
	test.Damage = -20
	test.Target = PlayerPos
	test.ProjectileSpeed = 10
	test.ProjectileRange = 40
	#sets the projectiles name to "Projectile" + a counter number
	#this is done so it can be referred to when a player hits the projectile
	var temp : String = ("Projectile")
	temp = temp + str(Counter)
	test.name = temp
	Counter = Counter + 1
	#adds it as a child to the current level
	World.add_child(test)
