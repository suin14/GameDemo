extends Interact

@onready var player: Player = $"../../player"

func interact() -> void:
	super()
	print("睡了一觉，度过了半小时")
	player.time_system.skip_time(30)
	#Game.save_game()
