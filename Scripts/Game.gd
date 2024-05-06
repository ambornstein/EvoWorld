extends Node2D

@export var inventory_ui: InventoryGUI
@export var player: Player
@export var health_bar: ProgressBar
@export var xp_bar: ProgressBar
@onready var stats = $Player/Camera2D/UI/TabBar/Stats

@onready var tab_bar = $Player/Camera2D/UI/TabBar

func toggle_inventory_interface():
	tab_bar.visible = not tab_bar.visible
	
func _ready():
	inventory_ui.set_player_inventory_data(player.inventory, player.equipment)
	player.health.change.connect(update_health)
	stats.load_stats(player.stats)

func update_health(health):
	health_bar.value = health

func _input(event):
	if event.is_action_pressed("inventory"):
		toggle_inventory_interface()
