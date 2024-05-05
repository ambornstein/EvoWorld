extends Area2D
class_name Item

@onready var sprite = $Sprite2D

@export var data: ItemData = preload("res://Resources/Item/axe.tres")

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.texture = data.texture

func _on_body_entered(body):
	if body is Player:
		if body.inventory.has_space():
			body.inventory.add_item(data)
			queue_free()
