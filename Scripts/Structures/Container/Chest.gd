extends StaticBody2D

@export var inventory: InventoryData
@onready var sprite: AnimatedSprite2D = $Sprite2D


func open():
	sprite.play("open")

func close():
	sprite.play("closed")
