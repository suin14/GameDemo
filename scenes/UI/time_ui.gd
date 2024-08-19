extends Control

@onready var date: Label = $DateControl/HBoxContainer/Date
@onready var hours: Label = $ClockControl/HBoxContainer/Hours
@onready var minutes: Label = $ClockControl/HBoxContainer/Minutes


func _on_time_system_updated(date_time: DateTime) -> void:
	var minu = date_time.minutes - (date_time.minutes % 5)
	update_label(date, date_time.days, false)
	update_label(hours, date_time.hours, true)
	update_label(minutes, minu, true)


func add_leading_zero(label: Label, value: int) -> void:
	if value < 10:
		label.text += '0'

func update_label(label: Label, value: int, should_have_zero: bool = true) -> void:
	label.text = ""
	
	if should_have_zero:
		add_leading_zero(label, value)
		
	label.text += str(value)

