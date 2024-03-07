extends PanelContainer

const Slot = preload("res://Scenes/Item/Slot.tscn")

@export var inv_data: InventoryData
@onready var item_grid = $MarginContainer/ItemGrid

func _ready():
	populate_item_grid(inv_data)

func set_inventory_data(inv: InventoryData):
	inv_data.inventory_updated.connect(populate_item_grid)
	populate_item_grid(inv)

func populate_item_grid(inv: InventoryData):
	clear_grid()
		
	for s in inv.slot_array:
		var slot = Slot.instantiate()
		item_grid.add_child(slot)
		
		slot.slot_clicked.connect(inv.on_slot_clicked)
		
		if s:
			slot.set_slot_data(s)
	
func clear_grid():
	for item in item_grid.get_children():
		item.queue_free()
