extends "res://Character/character.gd"

@onready var Head = $Head
@onready var ControlNode = $Head/Camera3D/Weapon/Control
@onready var DeathScreen = $DeathScreen
var CNBP
var CNTP
var CNRP
var CNLP
var Up
var Right
const JUMP_VELOCITY = 4.5

var PistolAmmo : int
var ShotgunAmmo : int

func _ready() -> void:
	set_physics_process(true)
	CNBP = ControlNode.position.y - 10
	CNTP = ControlNode.position.y + 10
	CNRP = ControlNode.position.x + 10
	CNLP = ControlNode.position.x - 10
	Health = 100
	MaxHealth = Health
	MoveSpeed = 8.0
	
func _process(delta: float) -> void:
	if Health <= 0:
		Engine.time_scale = 0
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		DeathScreen.show()


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("Left", "Right", "Forward", "Back")
	var direction = (Head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		_WeaponBob()
		velocity.x = direction.x * MoveSpeed
		velocity.z = direction.z * MoveSpeed
	else:
		velocity.x = move_toward(velocity.x, 0, MoveSpeed)
		velocity.z = move_toward(velocity.z, 0, MoveSpeed)

	move_and_slide()

func _WeaponBob():
	if Up == true:
		ControlNode.position.y = ControlNode.position.y + 0.6
		Head.position.y = Head.position.y + 0.008
		if CNTP <= ControlNode.position.y:
			Up = false
	else:
		ControlNode.position.y = ControlNode.position.y - 0.6
		Head.position.y = Head.position.y - 0.008
		if CNBP >= ControlNode.position.y:
			Up = true
	if Right == true:
		ControlNode.position.x = ControlNode.position.x + 0.5
		if CNRP <= ControlNode.position.x:
			Right = false
	else:
		ControlNode.position.x = ControlNode.position.x - 0.5
		if CNLP >= ControlNode.position.x:
			Right = true
