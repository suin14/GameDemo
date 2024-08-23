extends Interact

@export var item: InventoryItem

func interact():
	super()
	PlayerAction.addItem(item)
	print("获得食物")
	Game.done_action()
	
