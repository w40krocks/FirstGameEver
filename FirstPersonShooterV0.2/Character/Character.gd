extends CharacterBody3D

@onready var Front = $Front
@onready var Backward = $Back
@onready var Left = $Left
@onready var Right = $Right
@onready var Sprite = $CollisionShape3D/AnimatedSprite3D

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if Backward.get_overlapping_areas():
		print("backward")
		print(Backward.get_overlapping_areas())
	if Front.get_overlapping_areas():
		print("front ")
		print(Front.get_overlapping_areas())
		pass
