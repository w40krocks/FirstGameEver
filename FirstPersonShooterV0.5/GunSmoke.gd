extends Sprite3D

func _on_timer_timeout() -> void:
	if self.frame_coords.x == 0:
		self.frame_coords.x = 1
		$Timer.start
	else:
		queue_free()
