extends "res://Weapons/Projectile/ProjectileWeapon.gd"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	WeaponSpriteLocation = "res://Weapons/Projectile/Bazooka/BazookaSpriteSheetV1.png"
	HorizFrames = 4
	CurrentAnimation = 0
	WeaponScaleFactor = 4
	WeaponName = "Bazooka"
	AttackCooldown = 0.25
	MaxAmmo = 75
	CurrentAmmo = 10
	Damage = 10
	
	WeaponDisplaySprite = "res://Weapons/Projectile/Bazooka/BazookaPickupV1.png"
	DisplayWeaponScaleFactor = 3
	PrimaryWeaponColour = Color(0.3,0.3,1)
	
	SetSprite()
	SetDisplay()
	WeaponCooldown.wait_time = AttackCooldown
	AddSelectOption()
	FindSelectOption()
	WeaponProjectileScene = "res://Weapons/Projectile/Bazooka/Explosive.tscn"
	ProjectileSprite = "res://Weapons/Projectile/Bazooka/BazookaProjectile.png"
	ProjectileHframes = 11
	ProjectileRange = 20
	ProjectileSpeed = 10


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if CurrentAmmo > MaxAmmo:
		CurrentAmmo = MaxAmmo
	WeaponInfo.get_child(1).text = str(CurrentAmmo)
	WeaponSelect.get_child(1).text = str(CurrentAmmo)
	if visible:
		if Input.is_action_just_pressed("Attack") and WeaponCooldown.is_stopped() and CurrentAmmo > 0:
			Attack()
