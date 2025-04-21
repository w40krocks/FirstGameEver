extends Sprite2D

var Health
var IdleChoices
var AngryChoices
var FaceChoice
var Coords :Vector2
@onready var Player = $"../../.."
@onready var FaceTimer = $FaceSwapTimer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	FaceChoice = 0
	IdleChoices = [0,1,2] 
	AngryChoices = [3,4,5]
	
	#these numbers refer to the looking left, looking right, and
	#looking forward bits on the sprite

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#updates the health variable to be the sanem as the players health
	Health = Player.Health
	#if game is not paused run method
	if Engine.time_scale == 1:
		_FaceGeneration(Health,Coords)

func _FaceGeneration(Health,Coords):
	#determines the y coordiantes on the spritesheet based on the player health
	Coords.y = Health/Player.MaxHealth
	if str(Coords.y).length() >= 4:
		Coords.y = float(str(Coords.y).substr(0,-1))
	Coords.y = Coords.y*10
	self.frame_coords = (Coords)


func _SwapFaceXcoord() -> void:
	#runs when the faceTimer ends
	#runs independantly of the picking of the y coorrdinate
	if FaceChoice == 0:
		Coords.x = (IdleChoices.pick_random())
	elif FaceChoice == 1:
		Coords.x = (AngryChoices.pick_random())
	FaceTimer.start()
