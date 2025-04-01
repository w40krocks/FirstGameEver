extends Area3D

@onready var test = get_tree().current_scene.find_child("CharacterBody3D")

func _on_body_entered(body: Node3D) -> void:
	test.PistolUnlocked = true
	test._GunChoice(2)
	self.queue_free()
