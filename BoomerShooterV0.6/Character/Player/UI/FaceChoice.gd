extends Sprite2D

#----FaceCoords
@onready var IdleFace : Array = [0,1,2]
@onready var AngryFace : Array = [3,4,5]
@onready var FaceCoords = Vector2(0,0)
#----FaceCoords

#----FaceTimer
@onready var FaceTimer = $FaceXCooldown
#----FaceTimer


@onready var Player = self.get_parent().get_parent()

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void: 
	_FaceLocation()


func _FaceLocation():
	var temp = Player.Health/Player.MaxHealth
	if str(temp).length() >= 4:
		temp = float(str(temp).substr(0,-1))
	temp = temp *10
	FaceCoords.y = (temp)
	self.frame_coords = FaceCoords
	
func _FaceXCoordChange() -> void:
	if Player.IsAttacking == true:
		FaceCoords.x =AngryFace.pick_random()
	if Player.IsAttacking == false:
		FaceCoords.x =IdleFace.pick_random()
	FaceTimer.start()
	
