extends Node

static func  _ItemCheck(ItemType : Array) :
	var ItemReturn : Array = ["",0.0,"",0.0,true,0.0,0.0,0.0,0.0,0.0,"",0,0,[0.0,0.0,0.0],0]
	#[0,1,2,3,4,5R/5P,6R/6P]
#0 = Sprite file Location
#1 = Sprite Scale factor
#2 = Item Name
#3 = Consumable amount (10 health or 10 ammo)
#4 = isRaycast?		
#5R = RayScaleX		5P
#6R = RayscaleY		6P
#7R = RayTposZ		7P
#8 = Damage	
#9 = Ammo
#10 = WeaponTexture
#11 = HFrames
#12 = WeaponTimer
	match ItemType[0]:
		#Health
		0:
			match ItemType[1]:
				#Bandage
				0:
					ItemReturn[0] = "res://Item/Health/HealthPickup1.png"
					ItemReturn[1] = 5
					ItemReturn[2] = "Bandage"
					ItemReturn[3] = 10
				#Medkit
				1:
					ItemReturn[0] = "res://Item/Health/HealthPickup2.png"
					ItemReturn[1] = 5
					ItemReturn[2] = "Medkit"
					ItemReturn[3] = 50
		#Weapon
		1:
			match ItemType[1]:
				#Pistol
				0:
					ItemReturn[0] = "res://Weapon/RayWeapons/Ranged/Pistol/PistolV3Pickup.png"
					ItemReturn[1] = 5
					ItemReturn[2] = "Pistol"
					ItemReturn[3] = 10
					ItemReturn[4] = true
					ItemReturn[5] = 4
					ItemReturn[6] = 4
					ItemReturn[7] = 15
					ItemReturn[8] = 10
					ItemReturn[9] = 15
					ItemReturn[10] = "res://Weapon/RayWeapons/Ranged/Pistol/PistolV3SpriteSheet.png"
					ItemReturn[11] = 3
					ItemReturn[12] = 0.2
					ItemReturn[13] =[0.0313,0.6431,0.0784]
					ItemReturn[14] = 75
					
				#Shotgun
				1:
					ItemReturn[0] = "res://Weapon/RayWeapons/Ranged/Shotgun/ShotgunV3Pickup.png"
					ItemReturn[1] = 5
					ItemReturn[2] = "Shotgun"
					ItemReturn[3] = 10
					ItemReturn[4] = true
					ItemReturn[5] = 10
					ItemReturn[6] = 10
					ItemReturn[7] = 15
					ItemReturn[8] = 40
					ItemReturn[9] = 10
					ItemReturn[10] = "res://Weapon/RayWeapons/Ranged/Shotgun/ShotgunV3SpriteSheet.png"
					ItemReturn[11] = 3
					ItemReturn[12] = 0.5
					ItemReturn[13] = [0.8470,0.0784,0.2039]
					ItemReturn[14] = 50
				#Bazooka
				2:
					ItemReturn[0] = "res://Weapon/ProjectileWeapons/Bazooka/BazookaPickupV1.png"
					ItemReturn[1] = 5
					ItemReturn[2] = "Bazooka"
					ItemReturn[3] = 4
					ItemReturn[4] = false
					#ItemReturn[5] = 
					#ItemReturn[6] = 
					#ItemReturn[7] = 
					ItemReturn[8] = 10
					ItemReturn[9] = 10
					ItemReturn[10] = "res://Weapon/ProjectileWeapons/Bazooka/BazookaSpriteSheetV1.png"
					ItemReturn[11] = 4
					ItemReturn[12] = 1
					ItemReturn[13] = [0.0313,0.0784,0.6117]
					ItemReturn[14] = 20
		#Ammo
		2:
			match ItemType[1]:
				#Pistol
				0:
					ItemReturn[0] = "res://Weapon/Ammo/PistolAmmunitionV2.png"
					ItemReturn[1] = 5
					ItemReturn[2] = "PistolAmmo"
					ItemReturn[9] = 10
				#Shotgun
				1:
					ItemReturn[0] = "res://Weapon/Ammo/ShotgunAmmunitionV2.png"
					ItemReturn[1] = 5
					ItemReturn[2] = "ShotgunAmmo"
					ItemReturn[9] = 10
	return ItemReturn
