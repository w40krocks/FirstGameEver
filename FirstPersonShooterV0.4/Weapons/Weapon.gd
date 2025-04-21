extends RayCast3D

@onready var WeaponGroup = $Control
@onready var Self = $"."
@onready var WeaponTimer = $WeaponCooldown
@onready var AmmoLabel = $Ammo/Label
@onready var World = get_parent().get_parent().get_parent().get_parent()
@onready var Face = self.get_parent().get_child(1)
#[xScale,yScale,zTarget]
var CurrentRaycastDimensions : Array
var CurrentWeapon : String
var CurrentWeaponDamage : float
var CurrentAmmo

@onready var UnhandUnlock : bool = true
@onready var PistolUnlock : bool = false
var PistolAmmo : int
@onready var ShotgunUnlock : bool = false
var ShotgunAmmo : int

@onready var CooldownStatus : bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	CurrentRaycastDimensions = [0,0,0]
	_WeaponSelect(1)

func _process(delta: float) -> void:
	if CurrentWeapon != "Unhanded":
		if CurrentWeapon == "Shotgun":
			CurrentAmmo = ShotgunAmmo
		elif CurrentWeapon == "Pistol":
			CurrentAmmo = PistolAmmo
		AmmoLabel.text = str(CurrentAmmo)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("1"):
		_WeaponSelect(1)
	if event.is_action_pressed("2"):
		_WeaponSelect(2)
	if event.is_action_pressed("3"):
		_WeaponSelect(3)
	if Input.is_action_just_pressed("Attack") and CooldownStatus == false and Engine.time_scale == 1:
		CooldownStatus = true
		_TryAttack()

func _WeaponSelect(Choice):
	match Choice:
		#unhanded
		1:
			if UnhandUnlock == true:
				Self._WeaponReset()
				WeaponGroup.get_child(Choice - 1).show()
				CurrentRaycastDimensions[0] = 20
				CurrentRaycastDimensions[1] = 20
				CurrentRaycastDimensions[2] = -2
				CurrentWeaponDamage = -15
				WeaponTimer.wait_time = 0.75
				_SetWeapon(WeaponGroup.get_child(Choice - 1))
				AmmoLabel.text = ""
				CurrentWeapon = "Unhanded"
			else:
				pass
		#Pistol
		2:
			if PistolUnlock == true:
				Self._WeaponReset()
				WeaponGroup.get_child(Choice - 1).show()
				print(WeaponGroup.get_child(Choice - 1))
				CurrentRaycastDimensions[0] = 1
				CurrentRaycastDimensions[1] = 1
				CurrentRaycastDimensions[2] = -20
				CurrentWeaponDamage = -15
				WeaponTimer.wait_time = 0.5
				_SetWeapon(WeaponGroup.get_child(Choice - 1))
				CurrentAmmo = PistolAmmo
				CurrentWeapon = "Pistol"
			else:
				pass
		#Shotgun
		3:
			if ShotgunUnlock == true:
				Self._WeaponReset()
				WeaponGroup.get_child(Choice - 1).show()
				CurrentRaycastDimensions[0] = 10
				CurrentRaycastDimensions[1] = 10
				CurrentRaycastDimensions[2] = -15
				CurrentWeaponDamage = -40
				WeaponTimer.wait_time = 1
				_SetWeapon(WeaponGroup.get_child(Choice - 1))
				CurrentAmmo = ShotgunAmmo
				CurrentWeapon = "Shotgun"
			else:
				pass

func _WeaponReset():
	var MaxCounter = WeaponGroup.get_child_count()
	for i in MaxCounter:
		WeaponGroup.get_child(i).hide()

func _TryAttack():
	match CurrentWeapon:
		"Unhanded":
			_Attack()
		"Pistol":
			if PistolAmmo > 0:
				_Attack()
				PistolAmmo = PistolAmmo - 1
				CurrentAmmo = PistolAmmo
		"Shotgun":
			if ShotgunAmmo > 0:
				_Attack()
				ShotgunAmmo = ShotgunAmmo - 1
				CurrentAmmo = ShotgunAmmo
	WeaponTimer.start()
	
func _SetWeapon(Weapon):
	Self.target_position.z = CurrentRaycastDimensions[2]
	Self.scale.x = CurrentRaycastDimensions[0]
	Self.scale.y = CurrentRaycastDimensions[1]

func _AttackAnimation():
	if WeaponGroup.get_child(0).visible == true:
		Face.FaceChoice = 1
		$Control/Unhanded.play("Attack")

	elif WeaponGroup.get_child(1).visible == true:
		Face.FaceChoice = 1
		$Control/Pistol.play("Attack")
		
	elif WeaponGroup.get_child(2).visible == true:
		Face.FaceChoice = 1
		$Control/Shotgun.play("Attack")
		
func _on_weapon_cooldown_timeout() -> void:
	CooldownStatus = false
	var counter = WeaponGroup.get_child_count()
	for i in counter:
		WeaponGroup.get_child(i).play("Idle")
	Face.FaceChoice = 0
	

func _Attack():
	_AttackAnimation()
	if self.is_colliding():
		if self.get_collider().name.substr(0,4) == "Wall":
			print(self.get_collider())
			var BulletHole = Sprite3D.new()
			BulletHole.texture = load("res://World/Environment/Damage/impact.png")
			BulletHole.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
			BulletHole.rotation = self.get_collider().get_parent().rotation
			BulletHole.position = get_collision_point()
			var World = get_parent().get_parent().get_parent().get_parent()
			World.add_child(BulletHole)
			
		elif self.get_collider().name.substr(0,5) == "Enemy":
			print(self.get_collider())
			self.get_collider()._HealthChange(CurrentWeaponDamage)
			
		elif self.get_collider() is Area3D:
			if self.get_collider().KILL == 24:
				var temp = self.get_collider()
				temp.direction = temp.direction*-1
