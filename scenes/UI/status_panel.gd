class_name status_panel
extends PanelContainer

@export var status: Status

@onready var money_label: Label = $G/MoneyLabel
@onready var health_label: Label = $G/HealthLabel
@onready var hungry_label: Label = $G/HungryLabel
@onready var sanity_label: Label = $G/SanityLabel


func _ready() -> void:
	hide()
	if not status:
		status = Game.player_status

	status.money_changed.connect(update_money)
	update_money()
	
	status.health_changed.connect(update_health)
	update_health()
	
	status.hungry_changed.connect(update_hungry)
	update_hungry()
	
	status.sanity_changed.connect(update_sanity)
	update_sanity()
	
	visibility_changed.connect(func ():
		get_tree().paused = visible
	)
	
	tree_exited.connect(func ():
		status.money_changed.disconnect(update_money)
		status.health_changed.disconnect(update_health)
		status.hungry_changed.disconnect(update_hungry)
		status.sanity_changed.disconnect(update_sanity)
	)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") or event.is_action_pressed("ui_cancel"):
		hide()
		get_window().set_input_as_handled()


func update_money() -> void:
	money_label.text = str(status.money)
	
func update_health() -> void:
	health_label.text = str(status.health)
	
func update_hungry() -> void:
	hungry_label.text = str(status.hungry)
	
func update_sanity() -> void:
	sanity_label.text = str(status.sanity)
