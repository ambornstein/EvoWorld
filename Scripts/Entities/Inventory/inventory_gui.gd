extends Control
class_name InventoryGUI

@onready var inventory = $PlayerInventory/HFlowContainer/ItemPanel/ItemGrid
@onready var equipment = $PlayerInventory/HFlowContainer/EquipmentPanel/EquipmentGrid
@onready var container = $ContainerInventory/ItemPanel/ItemGrid
@onready var grabbed_slot = $Slot

var container_contents: InventoryData

var grabbed_slot_data: SlotData = null

func _process(delta):
	if container_contents:
		$ContainerInventory.show()
	else:
		$ContainerInventory.hide()

func _physics_process(delta):
	grabbed_slot.global_position = get_global_mouse_position() + Vector2(5,5)

func set_container_inventory_data(container_data: InventoryData):
	container_contents = container_data
	container_contents.inventory_interact.connect(on_inventory_interact)
	container.set_inventory_data(container_contents)

func disconnect_container_inventory():
	container_contents.inventory_interact.disconnect(on_inventory_interact)
	container_contents.inventory_updated.disconnect(container.populate_item_grid)
	container_contents = null
	container.clear_grid()

func set_player_inventory_data(inventory_data: InventoryData, equipment_data: InventoryData):
	inventory_data.inventory_interact.connect(on_inventory_interact)
	equipment_data.inventory_interact.connect(on_inventory_interact)

	equipment.set_inventory_data(equipment_data)
	inventory.set_inventory_data(inventory_data)

func on_inventory_interact(inventory_data: InventoryData, index: int, button: int):
	#print("%s %s %s" % [inventory_data, index, button])
	print(inventory_data)
	match [grabbed_slot_data, button]:
		[null, MOUSE_BUTTON_LEFT]:
			grabbed_slot_data = inventory_data.grab_slot_data(index)
		[_, MOUSE_BUTTON_LEFT]:
			if inventory_data.can_accept(grabbed_slot_data, index):
				grabbed_slot_data = inventory_data.drop_slot_data(grabbed_slot_data, index)

	update_grabbed_slot()

func update_grabbed_slot() -> void:
	if grabbed_slot_data:
		grabbed_slot.show()
		grabbed_slot.set_slot_data(grabbed_slot_data)
	else:
		grabbed_slot.hide()
