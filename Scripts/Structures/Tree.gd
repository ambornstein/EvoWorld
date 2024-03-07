extends StaticBody2D
class_name Forest

@export var structure_data: TreeData
@export var collision: CollisionShape2D
@export var icon: Sprite2D

@export var MAX_YIELD: int = 7
@export var size: int = 1

func set_tree_data(tree_data: TreeData):
	structure_data = tree_data
	
	replace_shape()
	icon.texture = structure_data.struct_texture

func replace_shape():
	collision.shape = structure_data.collision.collision_shape
	collision.transform.origin = structure_data.collision.collision_transform
	
func _ready():
	if structure_data:
		set_tree_data(structure_data)

func exhaust():
	var col = preload("res://Rescources/Structure/Collisions/bush_collision.tres")
	structure_data.chopped = true
	collision.transform.origin = col.collision_transform
	icon.texture = preload("res://Rescources/Structure/Tree/stump1.tres")

func harvest():
	size -= 1
	size = clamp(size, 1, MAX_YIELD)
