extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _WeaponReset(CurrentWeapon):
	for i in self.get_child_count():
		self.get_child(i)._HideWeapon()
		self.get_child(i).get_tree().paused = true
		CurrentWeapon._ShowWeapon()
		CurrentWeapon.get_tree().paused = false
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("PistolSelect"):
		if self.has_node("Pistol"):
			_WeaponReset($Pistol)
			
	if Input.is_action_just_pressed("ShotgunSelect"):
		if self.has_node("Shotgun"):
			print("heeeeee")
			_WeaponReset($Shotgun)
