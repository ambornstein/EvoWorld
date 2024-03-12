extends Node2D

@onready var inventory_ui: InventoryGUI = $Player/Camera2D/InventoryGUI
@onready var player: Player = $Player

func toggle_inventory_interface():
	inventory_ui.visible = not inventory_ui.visible
#
func _ready():
	inventory_ui.set_player_inventory_data(player.inventory, player.equipment)

func _input(event):
	if event.is_action_pressed("inventory"):
		toggle_inventory_interface()
