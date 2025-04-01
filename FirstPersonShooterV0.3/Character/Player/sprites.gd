extends Node2D

var CurrentPos
var TrueSpritePos : Vector2

@onready var Face = $Face
@onready var Player = $"../../.."

var Face1 = 0
var PlayerHealth
var SpriteChoice : Vector2
const Idle : Array = [0,1,2]
const Angry : Array = [3,4,5]

func _FaceChoice(FaceChoice):
	PlayerHealth = Player.Health
	#changes sprite y position based off of health
	if PlayerHealth >= 90:
		SpriteChoice.y = 0
	elif PlayerHealth >= 80 and PlayerHealth <90:
		SpriteChoice.y = 1
	elif PlayerHealth >= 70 and PlayerHealth <80:
		SpriteChoice.y = 2
	elif PlayerHealth >= 60 and PlayerHealth <70:
		SpriteChoice.y = 3
	elif PlayerHealth >= 50 and PlayerHealth <60:
		SpriteChoice.y = 4
	elif PlayerHealth >= 40 and PlayerHealth<50:
		SpriteChoice.y = 5
	elif PlayerHealth >= 30 and PlayerHealth <40:
		SpriteChoice.y = 6
	elif PlayerHealth >= 20 and PlayerHealth <30:
		SpriteChoice.y = 7
	elif PlayerHealth >= 10 and PlayerHealth <20:
		SpriteChoice.y = 8
	elif PlayerHealth > 0 and PlayerHealth <10:
		SpriteChoice.y = 9
	#Face 0 is Idle
	if FaceChoice == 0:
		SpriteChoice.x = (Idle.pick_random())
		Face.frame_coords = SpriteChoice
	#Face 1 is Angry
	if FaceChoice == 1:
		SpriteChoice.x = (Angry.pick_random())
		Face.frame_coords = SpriteChoice
#controls the time between sprite switches
func _on_timer_timeout() -> void:
	_FaceChoice(Face1)
