extends Area3D

var Damage : float
var ProjectileSpeed : float
var ProjectileRange : float
var SpawnLocation : Vector3
var Target : Vector3
var SpriteVector : Vector2
var Distance : float
var direction
@onready var KILL = 24
@onready var AnimationTimer = $Timer
@onready var Sprite = $Sprite3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	SpriteVector.x = int(0)
	SpriteVector.y = int(0)
	SpawnLocation = self.position
	direction = (Target - position).normalized()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	Distance = self.position.distance_to(SpawnLocation)
	self.position += direction * ProjectileSpeed * delta
	if Distance > ProjectileRange:
		self.queue_free()
	


func _OnBodyContact(body : Node3D) -> void:
	print(body)
	if body.name == "Player":
		body._HealthChange(Damage)
		self.queue_free()
	elif body.name.substr(0,5) == "Enemy":
		body._HealthChange(Damage)
		self.queue_free()
	else:
		self.queue_free()

func _Animation():
	Sprite.frame_coords = SpriteVector
	SpriteVector.x = SpriteVector.x + 1
	if SpriteVector.x == 4:
		SpriteVector.x = 0


func _on_timer_timeout() -> void:
	_Animation()
	AnimationTimer.start()
