class_name Status extends Node

signal money_changed
signal health_changed
signal tired_changed
signal hungry_changed
signal sanity_changed

@export var money_init: int = 1000
@export var max_health: int = 100
@export var max_tired: float = 100.0
@export var max_hungry: int = 100
@export var max_sanity: int = 100

var max_money: int  = 999999999

@onready var money: int = money_init:     #金钱
	set(v):
		v = clampi(v, 0, max_money)
		if money == v: return
		money = v
		money_changed.emit()

@onready var health: int = max_health:     #健康值
	set(v):
		v = clampi(v, 0, max_health)
		if health == v: return
		health = v
		health_changed.emit()

@onready var tired: float = max_tired:     #疲劳值
	set(v):
		v = clampf(v, 0, max_tired)
		if tired == v: return
		tired = v
		tired_changed.emit()

@onready var hungry: int = max_hungry:     #饥饿值
	set(v):
		v = clampi(v, 0, max_hungry)
		if hungry == v: return
		hungry = v
		hungry_changed.emit()

@onready var sanity: int = max_sanity:    #理智值
	set(v):
		v = clampi(v, 0, max_sanity)
		if sanity == v: return
		sanity = v
		sanity_changed.emit()




func _process(_delta: float) -> void:
	pass

func to_dict() -> Dictionary:
	return {
		max_health = max_health,
		health = health
	}
	
func from_dict(dict: Dictionary) -> void:
	max_health = dict.max_health
	health = dict.health

