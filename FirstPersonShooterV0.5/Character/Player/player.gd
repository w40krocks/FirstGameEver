extends "res://Character/character.gd"

#--ResourcesNeeded
var DeathSprite : String = "res://Character/CorpsePlaceholder.png"
@onready var PlayerUI = get_child(2)


const JUMP_VELOCITY = 4.5


var IsAttacking : bool

func _ready() -> void:
	Engine.time_scale = 1
	IsAttacking = false
	Health = 100
	MaxHealth = Health
	MoveSpeed = 7
	TurnSpeed = 0.025
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta: float) -> void:
	if Health <= 0:
		_Death(DeathSprite, self,self.get_parent(),true)
		
	if Health > MaxHealth:
		Health = MaxHealth
	
	if Input.is_action_just_pressed("Pause"):
		if Engine.time_scale == 0:
			Engine.time_scale = 1
		elif Engine.time_scale == 1:
			Engine.time_scale = 0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("Left", "Right", "Forward", "Backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * MoveSpeed
		velocity.z = direction.z * MoveSpeed
	else:
		velocity.x = move_toward(velocity.x, 0, MoveSpeed %4)
		velocity.z = move_toward(velocity.z, 0, MoveSpeed %4)
	move_and_slide()

func _input(event: InputEvent) -> void:
	if Engine.time_scale == 1:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		if event is InputEventMouseMotion:
			self.rotate_y(-event.relative.x * TurnSpeed)
			self.get_child(1).rotate_x(-event.relative.y * TurnSpeed)
			self.get_child(1).rotation.x = clamp(self.get_child(1).rotation.x, deg_to_rad(-40), deg_to_rad(60))
	elif Engine.time_scale ==0:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
