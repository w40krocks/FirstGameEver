extends Node3D
@onready var PlayerVec : Vector2
@onready var CharVec : Vector2

@onready var Play = $"../Player1"
@onready var Char = $"."
var CharPlay
var nChar
var Result
var charForward
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	charForward = -Char.global_transform.basis.z
	PlayerVec.x =(Play.Camera.global_position.x)
	PlayerVec.y =(Play.Camera.global_position.z)
	CharVec.x =(Char.global_position.x)
	CharVec.y =(Char.global_position.z)
	CharPlay = CharVec.direction_to(PlayerVec)
	nChar = Vector2(charForward.x, charForward.z).normalized()
	Result = CharPlay.dot(nChar)
	print(Result)
	if Result >0.75:
		print(Char.get_child(0))
		Char.get_child(0).play("Forward")
	
	if Result > -0.75 and Result < 0.75:
		print(Char.get_child(0))
		Char.get_child(0).play("Side") 
	if Result <-0.75:
		print(Char.get_child(0))
		Char.get_child(0).play("Backward")
	
	
