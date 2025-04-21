extends Node3D

@onready var EnviromentScript = load("res://World/Environment/EnviromentTexturing.gd")

@onready var WallTexture = load("res://World/Environment/Wall/BrickWall.png")
@onready var FloorTexture = load("res://World/Environment/Floor/Floor.png")
@onready var RoofTexture = load("res://World/Environment/Roof/Roof.png")

@onready var WallLocation = $Environment/Wall
@onready var RampLocation = $Environment/Ramp
@onready var FloorLocation = $Environment/Floor
@onready var RoofLocation = $Environment/Roof


var ItemCheck = load("res://Item/ItemCheck.gd")
var ItemInfo :Array
var counter = 0
var ItemSprite
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var EScriptInst = EnviromentScript.new()
	
	_GatherWorldItems()
	
	EScriptInst._ApplyTextures(WallLocation,WallTexture)
	EScriptInst._ApplyTextures(FloorLocation,FloorTexture)
	EScriptInst._ApplyTextures(RoofLocation,RoofTexture)
	EScriptInst._ApplyTextures(RampLocation,FloorTexture)
	
func _SetItems(Item):
	ItemSprite = Item.get_child(1)
	ItemInfo = ItemCheck._ItemCheck(Item.ItemType, 0, null)
	ItemSprite.texture = (load(ItemInfo[0]))
	ItemSprite.scale.x = int(ItemInfo[1])
	ItemSprite.scale.y = int(ItemInfo[1])

func _GatherWorldItems():
	var CurrentScene = $"Items"
	var c = CurrentScene.get_child_count()
	for counter in c:
		var Item = CurrentScene.get_child(counter)
		var ItemPath : String = Item.get_path()
		var PathLength = ItemPath.length()
		Item.ItemType = [int(ItemPath.substr(PathLength-2,1)) ,int(ItemPath.substr(PathLength - 1,1))]
		_SetItems(Item)
