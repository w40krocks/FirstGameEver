extends Container
@onready var PauseMenu = $".."
@onready var PauseState : bool = false
# Called when the node enters the scene tree for the first time.

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Pause"):
		_PauseMenu()

func _PauseMenu():
	if PauseState == false:
		Engine.time_scale = 0
		PauseMenu.show()
		PauseState = true
	elif PauseState == true:
		Engine.time_scale = 1
		PauseMenu.hide()
		PauseState = false

func _Resume() -> void:
	_PauseMenu()

func _Exit() -> void:
	get_tree().quit()
