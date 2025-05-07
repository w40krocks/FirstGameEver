extends Node3D

var Damage : float

@onready var Light =$OuterExplosion/Light
@onready var OuterExplosion = $OuterExplosion
@onready var OuterExplosionMesh = $OuterExplosion/OuterExplodeMesh
@onready var InnerExplosion = $InnerExplosion
@onready var InnerExplosionMesh = $InnerExplosion/InnerExplodeMesh


var Mat : StandardMaterial3D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$InnerExplosion.scale = Vector3(0.5,0.5,0.5)
	Light.omni_range = 0.5
	SetMeshMaterial($InnerExplosion/InnerExplodeMesh, Color(255,255,0,50))
	SetMeshMaterial($OuterExplosion/OuterExplodeMesh, Color(225,0,0,50))
	
	ExplostionTween($InnerExplosion)
	ExplostionTween($OuterExplosion)
	
func _process(_delta: float) -> void:
	if $OuterExplosion.scale.y < 0.5:
		queue_free()
	
func SetMeshMaterial(AppliedMesh, Colour):
	Mat = StandardMaterial3D.new()
	Mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	Mat.blend_mode =BaseMaterial3D.BLEND_MODE_ADD
	Mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	Mat.cull_mode =BaseMaterial3D.CULL_DISABLED
	Mat.albedo_color = Colour
	Mat.detail_blend_mode =BaseMaterial3D.BLEND_MODE_MUL
	AppliedMesh.set_surface_override_material(0,Mat)

	

func _Delete() -> void:
	queue_free()


func InnerExplosionEntered(body: Node3D) -> void:
	if body is CharacterBody3D:
		body._HealthChange(-Damage)


func OuterExplosionEntered(body: Node3D) -> void:
	print("hello!")
	print(body)
	if body is CharacterBody3D:
		body._HealthChange(-Damage)

func ExplostionTween(Explosion):
	var ExplodeMesh = Explosion.get_child(0)
	var tween := create_tween()
	#tween.EaseType.EASE_OUT_IN
	tween.parallel().tween_property(Explosion,"scale", Vector3(5,5,5),0.5)
	tween.parallel().tween_property(Light,"omni_range",5,0.5)
	tween.chain().tween_property(Explosion,"scale", Vector3(0.2,0.2,0.2),1)
	#tween.chain().parallel().tween_property(ExplodeMesh.get_surface_override_material(1),"albedo_color", Color(Explosion.get_active_material().albedo_color.r,Mat.albedo_color.g,Mat.albedo_color.b,0),1)
	#NOTE this last one doesnt seem to work, will need to look into it NOTE
