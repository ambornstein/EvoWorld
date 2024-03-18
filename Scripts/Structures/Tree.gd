extends StaticBody2D
class_name Forest

@export var structure_data: TreeData

@onready var hurt_box = $HurtBox

@export var MAX_YIELD: int = 7
@export var size: int = 1

func set_tree_data(tree_data: TreeData):
	structure_data = tree_data
	$Icon.texture = structure_data.struct_texture
	replace_shape()

func replace_shape():
	$Collision.shape = structure_data.collision.collision_shape
	$HurtBox.set_collision(structure_data.collision)
	
func _ready():
	hurt_box.health_bar.hurt.connect(_damaged_animation)

func exhaust():
	var col = preload("res://Resources/Structure/Collisions/bush_collision.tres")
	structure_data.chopped = true
	$Collision.transform.origin = col.collision_transform
	$Icon.texture = preload("res://Resources/Structure/Tree/stump1.tres")

func _damaged_animation():
	$Icon.modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	$Icon.modulate = Color.WHITE

func harvest():
	size -= 1
	size = clamp(size, 1, MAX_YIELD)
