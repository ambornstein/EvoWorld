extends StaticBody2D

@export var inventory: InventoryData
@onready var sprite: AnimatedSprite2D = $Sprite2D
var inv_enabled := false

func open():
	get_parent().toggle_inventory_interface()
	sprite.play("closed") if sprite.animation == "open" else sprite.play("open")

func close():
	get_parent().toggle_inventory_interface()
