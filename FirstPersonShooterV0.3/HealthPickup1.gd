extends Area3D

func _on_body_entered(body: Node3D) -> void:
	get_tree().current_scene.find_child("CharacterBody3D")._PlayerHealthChange(15)
	self.queue_free()
