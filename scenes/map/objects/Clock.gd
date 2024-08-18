extends Interact


func interact() -> void:
	super()
	print("正在保存……")
	Game.save_game()
