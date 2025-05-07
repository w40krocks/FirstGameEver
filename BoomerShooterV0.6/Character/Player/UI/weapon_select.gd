extends VBoxContainer

var SelectedOption : int
@onready var WeaponsLocation = find_parent("Player").find_child("Camera3D")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	HideUnusedWeapons()
	position.x -= size.x * scale.x
	SelectedOption = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	HighlightOption()

func _input(_event: InputEvent) -> void:
	if Input.is_action_pressed("WeaponSelect"):
		show()
	else:
		HideUnusedWeapons()
		hide()
	if visible:
		if Input.is_action_just_pressed("scroll down"):
			SelectedOption -= 1
			if SelectedOption < 0:
				SelectedOption = self.get_child_count() - 1
		
		elif Input.is_action_just_pressed("scroll up"):
			SelectedOption += 1
			if SelectedOption > self.get_child_count()-1:
				SelectedOption = 0



func HighlightOption():
	for i in get_child_count():
		get_child(i).modulate = Color(1,1,1)
	if SelectedOption > get_child_count()-1 and SelectedOption < 0:
		pass
	else:
		get_child(SelectedOption).modulate =Color(1,1,0)

func HideUnusedWeapons():
	for i in WeaponsLocation.get_child_count():
		if get_child(i).name != get_child(SelectedOption).name:
			WeaponsLocation.get_child(i).HideWeapon()
		else:
			WeaponsLocation.get_child(i).ShowWeapon()
