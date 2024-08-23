extends Control

@onready var inventory_gui: Control = $"."
@onready var inventory: Inventory = preload("res://content/data/player_inventory.tres")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()


func _ready() -> void:
	hide()
	visibility_changed.connect(func ():
		get_tree().paused = visible
	)
	inventory.updated.connect(update)
	update()
	

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_inventory") and inventory_gui.visible == true:
		hide()
		get_window().set_input_as_handled()

func update():
	for i in range(min(inventory.slots.size(), slots.size())):
		slots[i].update(inventory.slots[i])

