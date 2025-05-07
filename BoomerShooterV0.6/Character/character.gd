extends CharacterBody3D

#----HealthRelated
var Health 
var MaxHealth
#----HealthRelated

#----MovementRelated
var MoveSpeed
var TurnSpeed
#----MovementRelated

#----SpriteMalarky
var CharacterSpriteSheet
var CorpseSprite
#----SpriteMalarky


func _HealthChange(HealthChange : float):
	Health = Health + HealthChange


func _Death(CorpseResource : String, DeadCharacter, World, IsPlayerCharacter : bool):
	CorpseSprite = Sprite3D.new()
	CorpseSprite.texture = load(CorpseResource)
	CorpseSprite.position = DeadCharacter.position
	CorpseSprite.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
	CorpseSprite.name = self.name
	World.add_child(CorpseSprite)
	#checks if the dead character is a player
	if IsPlayerCharacter == true:
		#creates a new camera
		var temp = Camera3D.new()
		#sets the camera to a little behind the player
		temp.position = DeadCharacter.position
		temp.position.y += 2
		temp.rotation_degrees.x -= 90 
		CorpseSprite.billboard =BaseMaterial3D.BILLBOARD_ENABLED
		#adds the camera to the world
		World.add_child(temp)
		Engine.time_scale = 0

		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	DeadCharacter.queue_free()
