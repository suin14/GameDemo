class_name TimeSystem
extends Node

signal updated

@export var date_time: DateTime
@export var ticks_pre_second: int = 6

var time_paused: bool = false


func _process(delta: float) -> void:
	if time_paused: return

	date_time.increase_by_sec(delta * ticks_pre_second)
	updated.emit(date_time)


func to_dict() -> Dictionary:
	return {
		seconds = date_time.seconds,
		minutes = date_time.minutes,
		hours = date_time.hours,
		days = date_time.days
	}
	
func from_dict(dict: Dictionary) -> void:
	date_time.seconds = dict.seconds
	date_time.minutes = dict.minutes
	date_time.hours = dict.hours
	date_time.days = dict.days
