extends Node3D

@onready var NewMaterial = StandardMaterial3D.new()
var counter
var MeshInst

func _ApplyTextures(ObjectToChange,NewTexture):
	#creates instance of a standard mateiral3D
	var NewMaterial = StandardMaterial3D.new()
	print("hello")
	#gets the amount of children in the node that has been submitted into the method
	counter = ObjectToChange.get_child_count()
	#runs for the amount of the children the node has
	for i in counter:
		#sets the material texture to the texture submitted into the method
		NewMaterial.albedo_texture = NewTexture
		#makes the texture filter, not make the texture fuzzy
		NewMaterial.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
		#makes the back of the material not render, should help performance
		NewMaterial.cull_mode = BaseMaterial3D.CULL_BACK
		#sets the uv1 scale to the scale of the object being changed, should help with the streching
		#of images
		NewMaterial.uv1_scale = ObjectToChange.get_child(i).scale
		#gets the mesh location in the scene tree of the object
		MeshInst = ObjectToChange.get_child(i).get_child(0).get_child(1)
		#applies the new standard material to the mesh 
		MeshInst.material_override = NewMaterial
