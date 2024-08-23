class_name Inventory extends Resource

@export var slots: Array[InventorySlot]

signal updated

func insert(item: InventoryItem):
	var itemSlots = slots.filter(func(slot): return slot.item == item)
	if !itemSlots.is_empty() and itemSlots[0].amount < item.maxAmountPrStack:
		itemSlots[0].amount += 1
	else:
		var emptySlots = slots.filter(func(slot): return slot.item == null)
		if !emptySlots.is_empty():
			emptySlots[0].item = item
			emptySlots[0].amount = 1
	
	updated.emit()


func removeItemAtIndex(index: int):
	slots[index] = InventorySlot.new()

func insertSlot(new_index: int, inventorySlot: InventorySlot):
	var old_index: int = slots.find(inventorySlot)
	removeItemAtIndex(old_index)
	
	slots[new_index] = inventorySlot
