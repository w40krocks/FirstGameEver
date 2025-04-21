extends Node3D

@onready var FloorMaterial = load("res://World/Environment/Wall/WallTexturingTemplate.tres")
@onready var FloorTexture = load("res://World/Environment/Floor/Floor.png")
var counter
var MeshInst
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_ApplyTextures() 


func _ApplyTextures():
	print(FloorMaterial)
	counter = self.get_child_count()
	for i in counter:
		FloorMaterial.albedo_texture = FloorTexture
		FloorMaterial.uv1_scale = self.get_child(i).scale
		MeshInst =self.get_child(i).get_child(0).get_child(1)
		MeshInst.material_override = FloorMaterial
		
		
