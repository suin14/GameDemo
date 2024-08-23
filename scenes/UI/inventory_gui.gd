extends Control

@onready var inventory_gui: Control = $"."
@onready var inventory: Inventory = preload("res://content/data/player_inventory.tres")
@onready var ItemStackGuiClass = preload("res://scenes/UI/item_stack_gui.tscn")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()

var itemInHand: ItemStackGui

func _ready() -> void:
	hide()
	visibility_changed.connect(func ():
		get_tree().paused = visible
	)
	
	for i in range(slots.size()):
		var slot = slots[i]
		slot.index = i
		
		var callable = Callable(clickedSlot)
		callable = callable.bind(slot)
		slot.pressed.connect(callable)
	
	inventory.updated.connect(update)
	
	update()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_inventory") and inventory_gui.visible == true:
		hide()
		get_window().set_input_as_handled()
	
	updateItemInHand()

func update():
	for i in range(min(inventory.slots.size(), slots.size())):
		var inventorySlot: InventorySlot = inventory.slots[i]
		
		if !inventorySlot.item: continue
		
		var itemStackGui: ItemStackGui = slots[i].itemStackGui
		if !itemStackGui:
			itemStackGui = ItemStackGuiClass.instantiate()
			slots[i].insert(itemStackGui)
		
		itemStackGui.inventorySlot = inventorySlot
		itemStackGui.update()


func clickedSlot(slot):
	if slot.isEmpty():
		if !itemInHand: return
		
		insertItemInSlot(slot)
		return
	
	if !itemInHand:
		takeItemFromSlot(slot)

func takeItemFromSlot(slot):
	itemInHand = slot.takeItem()
	add_child(itemInHand)
	updateItemInHand()

func insertItemInSlot(slot):
	var item = itemInHand
	
	remove_child(itemInHand)
	itemInHand = null
	
	slot.insert(item)

func updateItemInHand():
	if !itemInHand: return
	itemInHand.global_position = get_global_mouse_position() - itemInHand.size / 2


