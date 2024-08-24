extends Control

@onready var inventory_gui: Control = $"."
@onready var inventory: Inventory = preload("res://content/data/player_inventory.tres")
@onready var ItemStackGuiClass = preload("res://scenes/UI/item_stack_gui.tscn")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()
@onready var item_view: CanvasLayer = $ItemView
@onready var item_name_label: Label = $ItemView/ItemViewBox/VBoxContainer/ItemNameLabel
@onready var item_description_label: Label = $ItemView/ItemViewBox/VBoxContainer/ItemDescriptionLabel
@onready var item_view_box: TextureRect = $ItemView/ItemViewBox


var itemInHand: ItemStackGui
var old_index: int = -1
var locked: bool = false

func _ready() -> void:
	hide()
	item_view.hide()
	visibility_changed.connect(func ():
		get_tree().paused = visible
	)
	
	for i in range(slots.size()):
		var slot = slots[i]
		slot.index = i
		
		var callable = Callable(clickedSlot)
		callable = callable.bind(slot)
		slot.pressed.connect(callable)
	
	for i in range(slots.size()):
		var slot = slots[i]
		slot.index = i
		
		var callable = Callable(viewsItem)
		callable = callable.bind(slot)
		slot.mouse_entered.connect(callable)
	
	for i in range(slots.size()):
		var slot = slots[i]
		slot.index = i
		
		var callable = Callable(cancelViewsItem)
		callable = callable.bind(slot)
		slot.mouse_exited.connect(callable)
	
	inventory.updated.connect(update)
	
	update()


func _input(event: InputEvent) -> void:
	if itemInHand and event.is_action_pressed("right_click") and !locked:
		replaceItem()

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
	if locked: return
	if slot.isEmpty():
		if !itemInHand: return
		
		insertItemInSlot(slot)
		return
	
	if !itemInHand:
		takeItemFromSlot(slot)
		return
	
	if slot.itemStackGui.inventorySlot.item.display_name == itemInHand.inventorySlot.item.display_name:
		stackItem(slot)
		return
	
	swapItems(slot)

func takeItemFromSlot(slot):
	itemInHand = slot.takeItem()
	add_child(itemInHand)
	
	updateItemInHand()
	
	old_index = slot.index

func insertItemInSlot(slot):
	var item = itemInHand
	
	remove_child(itemInHand)
	itemInHand = null
	
	slot.insert(item)
	
	old_index = -1

func updateItemInHand():
	if !itemInHand: return
	itemInHand.global_position = get_global_mouse_position() - itemInHand.size / 2

func swapItems(slot):
	var tmpItem = slot.takeItem()
	
	insertItemInSlot(slot)
	
	itemInHand = tmpItem
	add_child(itemInHand)
	updateItemInHand()

func replaceItem():
	locked = true
	if old_index < 0:  # 旧槽位被其他物品占用
		var emptySlots = slots.filter(func(slot): return slot.isEmpty())
		if emptySlots.is_empty(): return
		old_index = emptySlots[0].index
	
	var targetSlot = slots[old_index]
	
	var tween = create_tween()
	var targetPosition = targetSlot.global_position + targetSlot.size / 2
	tween.tween_property(itemInHand, "global_position", targetPosition, 0.1)
	await tween.finished
	insertItemInSlot(targetSlot)
	locked = false


func stackItem(slot):
	var slotItem: ItemStackGui = slot.itemStackGui
	var maxAmount = slotItem.inventorySlot.item.maxAmountPrStack
	var totalAmount = slotItem.inventorySlot.amount + itemInHand.inventorySlot.amount
	
	if slotItem.inventorySlot.amount == maxAmount:
		swapItems(slot)
		return
	if totalAmount <= maxAmount:
		slotItem.inventorySlot.amount = totalAmount
		remove_child(itemInHand)
		itemInHand = null
		old_index = -1
	else:
		slotItem.inventorySlot.amount = maxAmount
		itemInHand.inventorySlot.amount = totalAmount - maxAmount
	
	slotItem.update()
	if itemInHand: itemInHand.update()


func viewsItem(slot):
	if itemInHand or slot.isEmpty(): 
		item_view.hide()
		return
	showItemView(slot.itemStackGui.inventorySlot.item.display_name, slot.itemStackGui.inventorySlot.item.description)
	item_view_box.position = slot.global_position + slot.size

func showItemView(item_name: String, item_description: String):
	item_view.show()
	item_name_label.text = item_name
	item_description_label.text = item_description

func cancelViewsItem(_slot):
	item_view.hide()

