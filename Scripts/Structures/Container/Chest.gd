extends StaticBody2D

@export var inventory: InventoryData
@onready var sprite: AnimatedSprite2D = $Sprite2D
var inv_enabled := false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func open():
	get_parent().open_inventory(inventory)
	sprite.play("closed") if sprite.animation == "open" else sprite.play("open")

#dfunc _on_input_event(viewport, event, shape_idx):
	#if event is InputEventMouseButton and event.pressed:
		#print("chest clicked")
		
