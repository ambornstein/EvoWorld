extends StaticBody2D
class_name Boulder

@export var structure_data: BoulderData
@export var collision: CollisionShape2D
@export var icon: Sprite2D

@export var MAX_YIELD: int = 7
@export var size: int = 1

func set_boulder_data(boulder: BoulderData):
	structure_data = boulder
	icon.texture = structure_data.struct_texture
	
# Called when the node enters the scene tree for the first time.
func _ready():
	if structure_data:
		set_boulder_data(structure_data)
		
func exhaust():
	queue_free()

func harvest():
	size -= 1
	size = clamp(size, 1, MAX_YIELD)
