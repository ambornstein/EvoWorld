extends StaticBody2D
class_name Forest

@export var structure_data: TreeData
@export var collision: CollisionShape2D
@export var icon: Sprite2D
@export var health: HealthComponent

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
	health.hurt.connect(_damaged_animation)
	if structure_data:
		set_tree_data(structure_data)

func exhaust():
	var col = preload("res://Resources/Structure/Collisions/bush_collision.tres")
	structure_data.chopped = true
	collision.transform.origin = col.collision_transform
	icon.texture = preload("res://Resources/Structure/Tree/stump1.tres")

func _damaged_animation():
	icon.modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	icon.modulate = Color.WHITE

func harvest():
	size -= 1
	size = clamp(size, 1, MAX_YIELD)
