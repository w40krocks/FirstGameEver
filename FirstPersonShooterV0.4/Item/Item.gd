extends Area3D

	#determines the type of item
#0 = health
#	0,0 = Bandage
#	0,1 = Medkit
#1 = WeaponPickup
#	1,0 = Pistol
#	1,1 = Shotgun
#	1,2 = RocketLauncher
#2 = WeaponAmmo
#	2,0 = PistolAmmo
#	2,1 = ShotgunAmmo
#	2,2 = Rockets 
var ItemType : Array

var PickedItem : Array

@onready var WorldScene = get_parent().get_parent()
@onready var Weapon = $"../../Player/Head/Camera3D/Weapon"
var ItemCheck = load("res://Item/ItemCheck.gd")




func _bodyEntered(body: CharacterBody3D) -> void:
	print(WorldScene.scene_file_path)
	print(ItemType)
	PickedItem = ItemCheck._ItemCheck(ItemType, 1, body)
	PickedItem[2]
	
	print(body)
	if body.name == "Player":
		match PickedItem[2]:
			"Bandage":
				body._HealthChange(float(PickedItem[3]))
			"Medkit":
				print(body.Health)
				body._HealthChange(float(PickedItem[3]))
				print(body.Health)
			"Pistol":
				Weapon.PistolUnlock = true
				Weapon.PistolAmmo = Weapon.PistolAmmo + int(PickedItem[3])
			"Shotgun":
				Weapon.ShotgunUnlock = true
				Weapon.ShotgunAmmo = Weapon.ShotgunAmmo + int(PickedItem[3])
				print("Shotgun unlocked")
			"PistolAmmo":
				Weapon.PistolAmmo = Weapon.PistolAmmo + int(PickedItem[3])
				print(Weapon.PistolAmmo)
			"ShotgunAmmo":
				Weapon.ShotgunAmmo = Weapon.ShotgunAmmo + int(PickedItem[3])
				print(Weapon.ShotgunAmmo)
		queue_free()
