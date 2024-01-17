extends StaticBody2D
class_name Structure

enum MaterialContent {
	WOOD,
	LIMESTONE,
	CLAYSTONE,
	IRON,
	SILVER
}

@onready var small_shape = $CollisionSmall
@onready var medium_shape = $CollisionMedium
@onready var large_shape = $CollisionLarge

@export var resource: MaterialContent
@export_range(1,7) var size: int
var MAX_YIELD: int

@onready var sprite = $AnimatedSprite2D

func set_frame(i: int):
	sprite.frame = i
	
func set_animation(s: String):
	sprite.play(s)
	sprite.stop()
	
func select_collision(i: int):
	i = clamp(i, 0, 2)
	clear_collision()
	
	match i:
		0:
			small_shape.disabled = false
		1:
			medium_shape.disabled = false
		2:
			large_shape.disabled = false

func clear_collision():
	small_shape.disabled = true
	medium_shape.disabled = true
	large_shape.disabled = true
	
# Called when the node enters the scene tree for the first time.
func _ready():
	size = clamp(size, 1, MAX_YIELD)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func destroy():
	queue_free()
	
func harvest():
	size -= 1
	size = clamp(size, 1, MAX_YIELD)
