extends Interact


func interact() -> void:
	super()
	#Dialogic.start("Bed_sleep")
	PlayerStatus.money += 100
	Game.done_action()
	#Game.save_game()
