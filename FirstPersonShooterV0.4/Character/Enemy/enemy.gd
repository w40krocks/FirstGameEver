extends "res://Character/character.gd"
@onready var DeathSprite = load("res://Character/Enemy/CorpsePlaceholder.png")
@onready var Projectile = load("res://Weapons/projectile.tscn")

@onready var Player = self.get_parent().get_parent().get_child(0)
@onready var World = self.get_parent().get_parent()

@onready var Spotted = $Spotted
@onready var DetectionTimer = $DetectionTimer
@onready var Sprite = $Body
@onready var ObstructionCheck = $ObstructionCheck
@onready var AttackCooldown = $AttackCooldown
@onready var AttackSpawnLocation = $ProjectileSpawnLocation/MeshInstance3D

var SpriteCoords : Vector2
var SpottedStatus
var LostSight : bool
var Distance
var SelfVec : Vector2
var PlayerVec : Vector2
var SelfForward
var projSpawn
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SpriteCoords.x = 0
	LostSight = true
	SpottedStatus = false
	
	Health = 100
	MaxHealth = Health
	Distance = self.position.distance_to(Player.position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	projSpawn = AttackSpawnLocation.position
	if Health <= 0:
		_Death()
	if LostSight == true:
		_CheckIfSpotted()
	elif LostSight == false:
		DetectionTimer.start()
	
	_SpritePos()
	#print(DetectionTimer.time_left)
	
	if ObstructionCheck.rotation != ObstructionCheck.rotation - self.rotation:
		ObstructionCheck.rotation = Vector3(0,0,0) - self.rotation
	
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

func _Death():
	var CorpseSprite = Sprite3D.new()
	CorpseSprite.texture = DeathSprite
	CorpseSprite.position = self.position
	var World = self.get_parent().get_parent()
	World.add_child(CorpseSprite)
	queue_free()


func _Spotted(SpottedStatus):
	if SpottedStatus == true:
		Spotted.show()
		print("hellogoodsir")
		DetectionTimer.start()
		LostSight = false
		self.look_at(Player.position)
		if AttackCooldown.is_stopped() == true:
			AttackCooldown.start()
	else:
		SpottedStatus = false
		Spotted.hide()

func _CheckIfSpotted():
	Distance = self.position.distance_to(Player.position)
	if Distance <= 15 and _NormalPos(Player) >0.75:
		ObstructionCheck.target_position = Player.position - self.position
		if ObstructionCheck.get_collider() == Player:
			_Spotted(true)
		else:
			
			_Spotted(false)
	elif Distance <= 2:
	
		_Spotted(true)
	else:

		_Spotted(false)
	
func _SpritePos():
	var Result = _NormalPos(Player)
	
	if Result >0.75:
		SpriteCoords.y = 0
	elif Result > -0.75 and Result < 0.75:
		SpriteCoords.y = 1
	elif Result <-0.75:
		SpriteCoords.y = 2
	Sprite.frame_coords = SpriteCoords
	
func _NormalPos(OtherBody):
	SelfForward = -self.transform.basis.z
	PlayerVec.x =(OtherBody.get_child(2).global_position.x)
	PlayerVec.y =(OtherBody.get_child(2).global_position.z)
	SelfVec.x =(self.global_position.x)
	SelfVec.y =(self.global_position.z)
	var SelfToPlayer = SelfVec.direction_to(PlayerVec)
	var nSelf = Vector2(SelfForward.x, SelfForward.z).normalized()
	var Result = SelfToPlayer.dot(nSelf)
	return(Result)

func _DetectionTimerOver() -> void:
	LostSight = true
	print("notSpotted!")


func _Attack() -> void:
	var test = Projectile.instantiate()
	test.position = projSpawn
	
	test.Damage = -20
	World.add_child(test)
