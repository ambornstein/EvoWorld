extends Control

@onready var inventory = $Inventory
@onready var container = $ContainerItems
@onready var grabbed_slot = $Slot

var grabbed_slot_data: SlotData = null

func _ready():
	set_player_inventory_data(inventory.inv_data)
	set_container_inventory_data(container.inv_data)
	
func _physics_process(delta):
	if grabbed_slot.visible:
		grabbed_slot.global_position = get_global_mouse_position() + Vector2(5,5)
	
func set_container_inventory_data(container_data: InventoryData):
	container_data.inventory_interact.connect(on_inventory_interact)
	container.set_inventory_data(container_data)

func set_player_inventory_data(inventory_data: InventoryData):
	inventory_data.inventory_interact.connect(on_inventory_interact)
	inventory.set_inventory_data(inventory_data)

func on_inventory_interact(inventory_data: InventoryData, index: int, button: int):
	#print("%s %s %s" % [inventory_data, index, button])
	print(inventory_data)
	match [grabbed_slot_data, button]:
		[null, MOUSE_BUTTON_LEFT]:
			grabbed_slot_data = inventory_data.grab_slot_data(index)
		[_, MOUSE_BUTTON_LEFT]:
			grabbed_slot_data = inventory_data.drop_slot_data(grabbed_slot_data, index)
			
	update_grabbed_slot()

func update_grabbed_slot() -> void:
	if grabbed_slot_data:
		grabbed_slot.show()
		grabbed_slot.set_slot_data(grabbed_slot_data)
	else:
		grabbed_slot.hide()
