extends Area3D

@onready var character= $"../../CharacterBody3D"

func _ready() -> void:
	
	pass # Replace with function body.

func _on_area_3d_area_entered(area: Area3D) -> void:
	character._HealthChange(-20)
