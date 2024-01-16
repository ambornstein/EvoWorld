extends StaticBody2D
class_name Structure

enum MaterialContent {
	WOOD,
	LIMESTONE,
	CLAYSTONE,
	IRON,
	GOLD,
	PLATINUM
}

@export var resource: MaterialContent
@export var MAX_YIELD: int
var amount_left = MAX_YIELD

@onready var sprite = $AnimatedSprite2D

func set_frame(i: int):
	sprite.frame = i
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	# Called every frame. 'delta' is the elapsed time since the previous frame.
	
func _process(delta):
	sprite.frame = amount_left
	
func _destroy():
	pass
	
func _harvest():
	amount_left -= 1
	
func _damage():
	pass
