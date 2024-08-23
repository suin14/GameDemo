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
