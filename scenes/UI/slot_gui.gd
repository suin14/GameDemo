extends Button

@onready var slotSprite: Sprite2D = $Slot
@onready var container: CenterContainer = $CenterContainer
@onready var inventory: Inventory = preload("res://content/data/player_inventory.tres")

var itemStackGui: ItemStackGui
var index: int


func insert(isg: ItemStackGui):
	itemStackGui = isg
	slotSprite.frame = 1
	container.add_child(itemStackGui)
	
	if !itemStackGui.inventorySlot or inventory.slots[index] == itemStackGui.inventorySlot: return
	
	inventory.insertSlot(index, itemStackGui.inventorySlot)


func takeItem():
	var item = itemStackGui
	
	inventory.removeSlot(itemStackGui.inventorySlot)
	
	container.remove_child(itemStackGui)
	itemStackGui = null
	slotSprite.frame = 0
	
	return item


func isEmpty():
	return !itemStackGui
