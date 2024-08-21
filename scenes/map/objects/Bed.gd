extends Interact


func interact() -> void:
	super()
	#Dialogic.start("Bed_sleep")
	print(Game.player_status.money)
	Game.player_status.money += 100
	print(Game.player_status.money)
	#Game.save_game()
