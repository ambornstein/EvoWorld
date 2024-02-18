extends PanelContainer

const Slot = preload("res://Scenes/Item/Slot.tscn")

@export var inv_data: InventoryData
@onready var item_grid = $MarginContainer/ItemGrid

func set_inventory_data(inv: InventoryData):
	populate_item_grid(inv.slot_array)

func populate_item_grid(slots: Array[SlotData]):
	for item in item_grid.get_children():
		item.queue_free()
		
	for s in slots:
		var slot = Slot.instantiate()
		item_grid.add_child(slot)
		
		if s:
			slot.set_slot_data(s)
	
func _ready():
	#var inv_data = preload("res://Scenes/Item/Rescources/test_inv.tres")
	populate_item_grid(inv_data.slot_array)

func _enable():
	visible = true
	
func _disable():
	visible = false
	
func _toggle():
	visible = !visible
	
#func _clear_selection():
	#for item in get_children():
	
