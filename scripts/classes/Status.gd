extends Node

signal money_changed
signal health_changed
signal tired_changed
signal hungry_changed
signal sanity_changed

@export var init_money: int = 1000
@export var max_health: int = 100
@export var max_tired: float = 100.0
@export var max_hungry: int = 100
@export var max_sanity: int = 100

var max_money: int  = 999999999

@onready var money: int = init_money:     #金钱
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


func to_dict() -> Dictionary:
	return {
		money = money,
		health = health,
		tired = tired,
		hungry = hungry,
		sanity = sanity
	}
	
func from_dict(dict: Dictionary) -> void:
	money = dict.money
	health = dict.health
	tired = dict.tired
	hungry = dict.hungry
	sanity = dict.sanity

func init_status() -> Dictionary:
	return {
		money = init_money,
		health = max_health,
		tired = max_tired,
		hungry = max_hungry,
		sanity = max_sanity
	}

