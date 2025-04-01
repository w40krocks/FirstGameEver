extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const SENSITIVITY = 0.01

@export var Health = 100

@onready var Cam =  $Head/PlayerCam
@onready var Head = $Head

@onready var Unhanded =$Head/PlayerCam/RightWeapon/Unhanded
@onready var Shotgun =$Head/PlayerCam/MiddleWeapon/Shotgun
@onready var Pistol =$Head/PlayerCam/MiddleWeapon/Pistol
@onready var Face =$Head/PlayerCam/Face
@onready var FaceSprite =$Head/PlayerCam/Face/Face
@onready var Raycast1 =$Head/PlayerCam/WeaponRays/Raycast1
@onready var Raycast2 =$Head/PlayerCam/WeaponRays/Raycast2
@onready var Raycast3 =$Head/PlayerCam/WeaponRays/Raycast3

@onready var WeaponCooldown = $Cooldown
@onready var DeathMenu = $Head/PlayerCam/DeathMenu
var CurrentWeapon
var IsOnCooldown = false
var Damage
var Dimensons

var PistolUnlocked
var ShotgunUnlocked
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PistolUnlocked = false
	ShotgunUnlocked = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	_GunChoice(1)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("1"):
		_GunChoice(1)
	if Input.is_action_just_pressed("2"):
		_GunChoice(2)
	if Input.is_action_just_pressed("3"):
		_GunChoice(3)
		
	if Input.is_action_just_pressed("Attack") and IsOnCooldown == false:
		_Attack()
	print(Health)
#used to deal with mosue/camera movement
func _unhandled_input(event):
	#checks if game is paused, if not allows camera movement
	if Engine.time_scale == 1:
		if event is InputEventMouseMotion:
			Head.rotate_y(-event.relative.x * SENSITIVITY)
			Cam.rotate_x(-event.relative.y * SENSITIVITY)
			Cam.rotation.x = clamp(Cam.rotation.x, deg_to_rad(-40), deg_to_rad(60))
#controls player movement
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
	var direction = (Head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
#is ran whenever an a damage dealing entity collides with the player
func _PlayerHealthChange(HealthChange):
	Health = Health + HealthChange
	if Health > 100:
		Health = 100
	elif Health <= 0:
		FaceSprite.frame_coords.y = 10
		Engine.time_scale = 0
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		DeathMenu.show()
	
#changes the weapon depending on key pressed
func _GunChoice(GunChoice):
	#unhanded
	if GunChoice == 1:
		CurrentWeapon = Unhanded
		Dimensons = [40,-3]
		_GunReset()
		Damage = 7
		Unhanded.show()
		Raycast1.target_position.z = Dimensons[1]
		Raycast1.scale.x = Dimensons[0]
		Raycast1.scale.y = Dimensons[0]
	#Pistol
	elif GunChoice == 2 and PistolUnlocked == true:
		CurrentWeapon = Pistol
		Dimensons = [10,-12]
		_GunReset()
		Damage = 3
		Pistol.show()
		Raycast1.target_position.z = Dimensons[1]
		Raycast1.scale.x = Dimensons[0]
		Raycast1.scale.y = Dimensons[0]
	#Shotgun
	elif GunChoice == 3 and ShotgunUnlocked == true:
		CurrentWeapon = Shotgun
		Dimensons = [10,-8,-0.2,0.2]
		_GunReset()
		Damage = 8
		Shotgun.show()
		Raycast1.target_position.z = Dimensons[1]
		Raycast1.scale.x = Dimensons[0]
		Raycast1.scale.y = Dimensons[0]
		Raycast2.target_position.z = Dimensons[1]
		Raycast2.target_position.z = Dimensons[2]
		Raycast2.scale.x = Dimensons[0]
		Raycast2.scale.y = Dimensons[0]
		Raycast3.target_position.z = Dimensons[1]
		Raycast3.target_position.z = Dimensons[3]
		Raycast3.scale.x = Dimensons[0]
		Raycast3.scale.y = Dimensons[0]
#resets all gun related stats
func _GunReset():
	Damage = 0
	Unhanded.hide()
	Shotgun.hide()
	Pistol.hide()
	Raycast1.scale.x = 1
	Raycast1.target_position.x = 0
	Raycast3.scale.x = 1
	Raycast2.target_position.x = 0
	Raycast2.scale.x = 1
	Raycast3.target_position.x = 0
	Raycast1.scale.y = 1
	Raycast1.target_position.y = 0
	Raycast3.scale.y = 1
	Raycast2.target_position.y = 0
	Raycast2.scale.y = 1
	Raycast3.target_position.y = 0
	Raycast1.scale.z = 1
	Raycast1.target_position.z = 0
	Raycast3.scale.z = 1
	Raycast2.target_position.z = 0
	Raycast2.scale.z = 1
	Raycast3.target_position.z = 0
#checks if the player hits anyone with their shot
func _Attack():
	IsOnCooldown = true
	if CurrentWeapon == Pistol:
		WeaponCooldown.start(0.5)
	elif CurrentWeapon == Shotgun:
		WeaponCooldown.start(1.5)
	elif CurrentWeapon == Unhanded:
		WeaponCooldown.start(1)
	CurrentWeapon.play("Attack")
	Face.Face1 = 1
#controls time between shots
func _WeaponCooldownDone() -> void:
	IsOnCooldown = false
	CurrentWeapon.play("Idle")
	Face.Face1 = 0
