class_name ItemStackGui extends Panel

@onready var itemSprite: Sprite2D = $ItemSprite
@onready var amountLabel: Label = $Amount

var inventorySlot: InventorySlot

func update():
	if !inventorySlot or !inventorySlot.item: return
	
	itemSprite.show()
	itemSprite.texture = inventorySlot.item.texure
	if inventorySlot.amount > 1:
		amountLabel.show()
		amountLabel.text = str(inventorySlot.amount)
	else:
		amountLabel.hide()
