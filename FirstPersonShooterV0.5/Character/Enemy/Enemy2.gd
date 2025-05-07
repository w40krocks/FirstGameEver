extends "res://Character/character.gd"

#------OutOfSceneStuff
@onready var World = self.get_parent().get_parent()
@onready var Player = self.World.find_child("Player")
@onready var DeathSprite = "res://Character/CorpsePlaceholder.png"
@onready var Projectile = load("res://Weapon/ProjectileWeapons/projectile.tscn")
#------OutOfSceneStuff

#------InSceneStuff
@onready var Sprite = $Body
@onready var SpottedSignal = $Spotted
@onready var DetectionTimer =$DetectionTimer
@onready var AttackTimer = $AttackCooldown
@onready var ProjectileSpawner = $ProjectileSpawnLocation
@onready var ObstructionCheck = $ObstructionCheck
@onready var AnimationTimer =$AnimationTimer
#------InSceneStuff

#------SpriteStuff
var SpriteCoords : Vector2
#------SpriteStuff

#------LookoutStuff
var Distance : float
var PlayerSpotted : bool
var PlayerPos : Vector3
var Counter
var RotationalDistance : float
#------LookoutStuff

#------ActionChecks
var isAttacking : bool
var AttackAnimation : int
var isMoving : bool
var MovingAnimation : int
#------ActionChecks

func _ready() -> void:
	Health = 50
	MaxHealth = Health
	PlayerSpotted = false
	isAttacking = false
	isMoving = true
	AttackAnimation = 3
	MovingAnimation = 1

func _process(delta: float) -> void:
	Distance = self.position.distance_to(Player.position)
	RotationalDistance = self.rotation_degrees.y -Player.rotation_degrees.y
	
	
	
	if isAttacking == true:
		if AnimationTimer.is_stopped():

			AnimationTimer.start()
			
			
	elif isMoving == true:
		if AnimationTimer.is_stopped():
			AnimationTimer.start()

	else:
		SpriteCoords.x = 0
	
	if PlayerSpotted == false:
		SpottedSignal.hide()
		_CheckIfSpotted()
	else:
		_IsSpotted()
		
	
	_SpriteRotation()

	

func _CheckIfSpotted():
	if Distance < 2:
		PlayerSpotted = true
		#has been spotted
	if Distance < 20:
		#is within spotting range
		if RotationalDistance < -135 or RotationalDistance > 135:
			PlayerSpotted =_CheckForObstruction()
			#has been spotted
	

func _CheckForObstruction():
	ObstructionCheck.target_position = Player.position - self.position
	ObstructionCheck.rotation = Vector3(0,0,0) - self.rotation
	
	if ObstructionCheck.get_collider() != null:
		print(ObstructionCheck.get_collider().name)
		if ObstructionCheck.get_collider().name == "Player":
			#isSpotted
			print("spotted")
			return true
		else:
			print("not spotted") 
			return false
	else:
		return false

func _IsSpotted():
	SpottedSignal.show()

func _SpriteRotation():
	#show front sprite
	if RotationalDistance < -135 or RotationalDistance > 135:
		SpriteCoords.y = 0 
		Sprite.flip_h = false
		
	#show right sprite
	elif RotationalDistance < -45 and RotationalDistance > -135:
		SpriteCoords.y = 1
		Sprite.flip_h = false

	#show left sprite
	elif RotationalDistance > 45 and RotationalDistance < 135:
		SpriteCoords.y = 1
		Sprite.flip_h = true

	#show back sprite
	elif RotationalDistance > -45 and RotationalDistance < 45:
		SpriteCoords.y = 2
		Sprite.flip_h = false
	
	#sets sprite coords
	Sprite.frame_coords = SpriteCoords


func _Animation() -> void:
	if isAttacking == true:
		print(AttackAnimation)
		AttackAnimation += 1
		SpriteCoords.x = AttackAnimation
	elif isMoving == true:
		print(MovingAnimation)
		MovingAnimation += 1
		SpriteCoords.x = MovingAnimation
	
	if AttackAnimation == 4:
		AttackAnimation = 2

	if MovingAnimation == 2:
		MovingAnimation = 0
