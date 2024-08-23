extends Control

@onready var inventory_gui: Control = $"."


func _ready() -> void:
	hide()
	
	visibility_changed.connect(func ():
		get_tree().paused = visible
	)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_inventory") and inventory_gui.visible == true:
		hide()
		get_window().set_input_as_handled()



