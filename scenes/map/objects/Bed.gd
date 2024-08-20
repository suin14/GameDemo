extends Interact


func interact() -> void:
	super()
	Dialogic.start("Bed_sleep")
	
	#Game.save_game()
