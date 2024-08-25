class_name Inventory extends Resource

@export var slots: Array[InventorySlot]

signal updated

func insert(item: InventoryItem):
	var itemSlots = slots.filter(func(slot): return slot.item == item and slot.amount < slot.item.maxAmountPrStack)
	if !itemSlots.is_empty():
		itemSlots[0].amount += 1
	else:
		var emptySlots = slots.filter(func(slot): return slot.item == null)
		if !emptySlots.is_empty():
			emptySlots[0].item = item
			emptySlots[0].amount = 1
	
	updated.emit()


func removeSlot(inventorySlot: InventorySlot):
	var index = slots.find(inventorySlot)
	if index < 0: return
	slots[index] = InventorySlot.new()

func insertSlot(new_index: int, inventorySlot: InventorySlot):
	slots[new_index] = inventorySlot


func to_dict() -> Dictionary:
	var dict: Dictionary = {}
	for i in range(slots.size()):
		var item_name = "null"
		if slots[i].item != null:
			item_name = slots[i].item.name
		dict[i] = {
			"item_name": item_name,
			"amount": slots[i].amount
		}
	return dict


func from_dict(dict: Dictionary) -> void:
	for i in range(slots.size()):
		if dict.has(str(i)):
			var item_resource = load("res://content/objects/" + dict[str(i)].item_name + ".tres")
			if item_resource != null:
				slots[i].item = item_resource
			slots[i].amount = dict[str(i)].amount


func init() -> void:
	for i in range(slots.size()):
		slots[i].item = null
		slots[i].amount = 0
