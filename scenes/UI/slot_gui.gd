extends Button

@onready var slotSprite: Sprite2D = $Slot
@onready var container: CenterContainer = $CenterContainer

var itemStackGui: ItemStackGui

func insert(isg: ItemStackGui):
	itemStackGui = isg
	slotSprite.frame = 1
	container.add_child(itemStackGui)
	
