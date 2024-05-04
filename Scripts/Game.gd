extends Node2D

@export var inventory_ui: InventoryGUI
@export var player: Player
@export var health_bar: ProgressBar
@export var xp_bar: ProgressBar

func toggle_inventory_interface():
	inventory_ui.visible = not inventory_ui.visible
#
func _ready():
	inventory_ui.set_player_inventory_data(player.inventory, player.equipment)
	player.health.change.connect(update_health)

func update_health(health):
	health_bar.value = health

func _input(event):
	if event.is_action_pressed("inventory"):
		toggle_inventory_interface()
