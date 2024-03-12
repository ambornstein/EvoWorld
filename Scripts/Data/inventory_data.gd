extends Resource
class_name InventoryData

signal inventory_updated(inventory_data: InventoryData)
signal inventory_interact(inventory_data: InventoryData, index: int, button: int)

@export var slot_array: Array[SlotData]
@export_enum("Equipment") var slot_restriction

enum EquipmentType {
	HELMET,
	WEAPON,
	CHEST,
	SHIELD,
	LEG,
	LEFT_RING,
	BOOT,
	RIGHT_RING
}

func on_slot_clicked(index: int, button: int):
	print("%s %s" % [index, button])
	inventory_interact.emit(self, index, button)

func grab_slot_data(index: int):
	var slot_data = slot_array[index]
	if slot_data:
		slot_array[index] = null
		inventory_updated.emit(self)
		return slot_data
	else:
		return null
		
func get_slot_data(index: int):
	return slot_array[index]

func drop_slot_data(grabbed_slot_data: SlotData, index: int):
	var slot_data = slot_array[index]
	
	var return_slot_data: SlotData
	if slot_data and slot_data.can_fully_merge_with(grabbed_slot_data):
		slot_data.fully_merge_with(grabbed_slot_data)
	else:
		slot_array[index] = grabbed_slot_data
		return_slot_data = slot_data
		
	inventory_updated.emit(self)
	return return_slot_data

func can_accept(grabbed_slot_data: SlotData, index: int):
	match[slot_restriction]:
		[null]:
			return true
		[0]:
			print(grabbed_slot_data.item_data.equip_type)
			if grabbed_slot_data.item_data.equip_type == index:
				return true
			else:
				return false
