extends Node

static func  _ItemCheck(ItemType, ItemDecison, EnteredBody) :
	var ItemReturn : Array = ["","","",""]
	#[0,1,2,3]
#0 = Sprite file Location
#1 = Sprite Scale factor
#2 = Item Name
#3 = Consumable amount (10 health or 10 ammo)

	match ItemType[0]:
		#Health
		0:
			match ItemType[1]:
				#Bandage
				0:
					ItemReturn[0] = "res://Item/Health/HealthPickup1.png"
					ItemReturn[1] = "5"
					ItemReturn[2] = "Bandage"
					ItemReturn[3] = "10"
				#Medkit
				1:
					ItemReturn[0] = "res://Item/Health/HealthPickup2.png"
					ItemReturn[1] = "5"
					ItemReturn[2] = "Medkit"
					ItemReturn[3] = "50"
		#Weapon
		1:
			match ItemType[1]:
				#Pistol
				0:
					ItemReturn[0] = "res://Item/WeaponPickup/PistolV2Pickup.png"
					ItemReturn[1] = "5"
					ItemReturn[2] = "Pistol"
					ItemReturn[3] = "10"
				#Shotgun
				1:
					ItemReturn[0] = "res://Item/WeaponPickup/ShotgunV2Pickup.png"
					ItemReturn[1] = "5"
					ItemReturn[2] = "Shotgun"
					ItemReturn[3] = "10"
		#Ammo
		2:
			match ItemType[1]:
				#Pistol
				0:
					ItemReturn[0] = "res://Item/Ammo/PistolAmmunitionV1.png"
					ItemReturn[1] = "5"
					ItemReturn[2] = "PistolAmmo"
					ItemReturn[3] = "10"
				#Shotgun
				1:
					ItemReturn[0] = "res://Item/Ammo/ShotgunAmmunitionV1.png"
					ItemReturn[1] = "5"
					ItemReturn[2] = "ShotgunAmmo"
					ItemReturn[3] = "10"
	return ItemReturn
