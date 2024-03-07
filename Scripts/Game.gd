extends Node2D

@onready var inventory_ui = $Player/Camera2D/InventoryUI
@onready var player = $Player

func toggle_inventory_interface():
	inventory_ui.visible = not inventory_ui.visible

func _input(event):
	if event.is_action_pressed("inventory"):
		toggle_inventory_interface()
