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
var ItemInfo : Array

var PickedItem : Array

@onready var RayWeapons = load("res://Weapon/RayWeapons/RayWeapon.tscn")

var Weapon
@onready var WorldScene = get_parent().get_parent()

var ItemCheck = load("res://Item/ItemCheck.gd")

func _ready() -> void:
	ItemType = [0,0]
	ItemType = [int(self.name.substr(self.name.length()-2,1)) ,int(self.name.substr(self.name.length() - 1,1))]
	print(ItemType)
	PickedItem = ItemCheck._ItemCheck(ItemType)
	self.get_child(1).texture = load(PickedItem[0])
	self.get_child(1).scale.x = float(PickedItem[1])
	self.get_child(1).scale.y = float(PickedItem[1])






func _bodyEntered(body: CharacterBody3D) -> void:
	Weapon = body.find_child("Weapon")
	print(ItemType)
	print(body)
	if body.name == "Player":
		match PickedItem[2]:
			"Bandage":
				body._HealthChange(float(PickedItem[3]))
				queue_free()
			"Medkit":
				body._HealthChange(float(PickedItem[3]))
				queue_free()
			"Pistol":
				_AddWeaponToCharacter(body)
				queue_free()
			"Shotgun":
				_AddWeaponToCharacter(body)
				queue_free()
			"PistolAmmo":
				_AddAmmo(body)
			"ShotgunAmmo":
				_AddAmmo(body)

func _AddWeaponToCharacter(Player):
	var WeaponLocation = Player.find_child("Weapon")
	var ExistCheck = _CheckIfPlayerHasWeapon()
	if ExistCheck[1] == true:
		ExistCheck[0].Ammo += float(PickedItem[3])
	else:
		var temp = RayWeapons.instantiate()
		temp.name = PickedItem[2]
		Weapon.add_child(temp)
		temp._SetWeaponInfo([PickedItem[5],PickedItem[6],PickedItem[7],PickedItem[8],PickedItem[9],PickedItem[10],PickedItem[11],PickedItem[12],PickedItem[0],PickedItem[13],PickedItem[14]])
		temp._SetWeaponSprite()

func _AddAmmo(Player):
	var WeaponLocation = Player.find_child("Weapon")
	var temp = PickedItem[2] 
	PickedItem[2] = PickedItem[2].substr(0,PickedItem[2].length()-4)
	var ExistCheck = _CheckIfPlayerHasWeapon()
	PickedItem[2] = temp
	if ExistCheck[1] == true:
		if ExistCheck[0].Ammo != ExistCheck[0].MaxAmmo:
			ExistCheck[0].Ammo += float(PickedItem[9])
			self.queue_free()

func _CheckIfPlayerHasWeapon():
	var ReturnInfo : Array = [0,false]
	if  Weapon.get_child(0) == null:
		ReturnInfo[0] = 0
		ReturnInfo[1] = false
	elif Weapon.get_child_count()> 0:
		for i in Weapon.get_child_count():
			if Weapon.get_child(i).name == PickedItem[2]: 
				ReturnInfo[0] = Weapon.get_child(i)
				ReturnInfo[1] = true
			else:
				pass
	return ReturnInfo
