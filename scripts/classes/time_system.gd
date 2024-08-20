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
