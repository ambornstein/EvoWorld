extends Node2D

@onready var inventory = $Player/Camera2D/Inventory
@onready var container = $Player/Camera2D/ContainerItems

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func open_inventory(inv_data: InventoryData):
	container.set_inventory_data(inv_data)
	
func _input(event):
	if event.is_action_pressed("inventory"):
		inventory._toggle()
		container._toggle()
