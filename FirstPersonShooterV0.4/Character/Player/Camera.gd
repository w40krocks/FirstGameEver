extends Node3D

@onready var Head = $"."
@onready var Cam = $Camera3D
@onready var Sensitivity = 0.02


func _unhandled_input(event):
	#checks if game is paused, if not allows camera movement
	if Engine.time_scale == 1:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		if event is InputEventMouseMotion:
			Head.rotate_y(-event.relative.x * Sensitivity)
			Cam.rotate_x(-event.relative.y * Sensitivity)
			#sets the limits of the camera movement so that you cant look into yourself 
			#or look behind yourself by looking upward
			Cam.rotation.x = clamp(Cam.rotation.x, deg_to_rad(-70), deg_to_rad(80)) 
	#if game is paused mouse is set to visible
	elif Engine.time_scale == 0:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
