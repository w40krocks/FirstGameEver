extends Container


func _on_restart_pressed() -> void:
	#game is unpasued and current level is restarted
	Engine.time_scale = 1
	get_tree().reload_current_scene()


func _on_quit_pressed() -> void:
	get_tree().quit()
