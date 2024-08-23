extends Node

@onready var inventory: Inventory = preload("res://content/data/player_inventory.tres")

func addItem(item: InventoryItem):
	inventory.insert(item)
