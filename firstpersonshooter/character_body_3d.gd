extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const SENSITIVITY = 0.01
var Health = 100.0
var HealthChangeCheck = 100.0

#calls nodes as variables
@onready var head = $Head
@onready var camera = $Head/Camera3D
@onready var Gun = $Head/Camera3D/Gun
@onready var Shot = $Head/Camera3D/GunCast
@onready var face = $Head/Camera3D/Label/Face
@onready var HealthRep = $"../HealthContainer2"
@onready var HealthPickup1 = $"../HealthPickup1/HealthShape/Area3D"
@onready var DeathMenu = $"../Death Screen"
@onready var DeathBackground = $"../DeathBackground"

func _ready():
	face.play("default")
	print("testing")
	#hides the mouse
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _Shoot():
	Gun.play("Shoot")
	face.play("Angry")
	if Shot.is_colliding() == true:
		print("Hit a shot!")
		print(Shot.get_collider())
		if Shot.get_collider() == $"../HealthPickup":
			_HealthChange(25)
			pass
		
func _HealthChange(health):
	Health = Health + health
	if Health > 100:
		Health = 100
	HealthRep.scale.x = Health /100
	HealthRep.scale.y = Health /100
	HealthChangeCheck = Health

	
func _Death():
	face.play("Death")
	DeathMenu.show()
	DeathBackground.show()
	Engine.time_scale == 0
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	#check if player has any stored extra lives, if so reset health to 100 and -1 to extra lives
	#if not bring up game over menu two options exit or restart
	#exit turns off game
	#restart button restarts scene
	pass

func _process(delta: float):
	if Health <= 0:
		_Death()
	if Health != HealthChangeCheck:
		_HealthChange(0)
	if Input.is_action_just_pressed("Shoot"):
		_Shoot()
	if Input.is_action_just_pressed("INSTANT DEATH"):
		Health = 0

#allows camera movement with the mouse
func _unhandled_input(event):
	if Engine.time_scale == 1:
		if event is InputEventMouseMotion:
			head.rotate_y(-event.relative.x * SENSITIVITY)
			camera.rotate_x(-event.relative.y * SENSITIVITY)
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-40), deg_to_rad(60))
	else:
		pass

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = 0.0
		velocity.z = 0.0
		pass

	move_and_slide()

func _on_gun_2_animation_looped() -> void:
	Gun.play("Default")
	face.play("default")
	pass 



	
