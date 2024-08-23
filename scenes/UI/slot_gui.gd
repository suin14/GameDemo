extends Panel

@onready var slotSprite: Sprite2D = $Slot
@onready var itemSprite: Sprite2D = $CenterContainer/Panel/Item
@onready var amountLabel: Label = $CenterContainer/Panel/Amount


func update(slot: InventorySlot):
	if !slot.item:
		slotSprite.frame = 0
		itemSprite.hide()
		amountLabel.hide()
	else:
		slotSprite.frame = 1
		itemSprite.show()
		itemSprite.texture = slot.item.texure
		amountLabel.show()
		if slot.amount > 1:
			amountLabel.text = str(slot.amount)
