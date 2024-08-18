extends State

func enter():
	pass
	


func physics_update(_delta: float):
	if player.move_direction:
		ChangeState.emit(self, "walk")
	else:
		player.animation_player.play("idle")
		

