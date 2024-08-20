extends State

func enter():
	pass
	


func physics_update(_delta: float):
	if player.move_direction:
		player.velocity = player.move_direction * player.MOVE_SPEED
		
		if player.velocity.x > 0:
			player.direction = "right"
		elif player.velocity.x < 0:
			player.direction = "left"
		elif player.velocity.y > 0:
			player.direction = "down"
		elif player.velocity.y < 0:
			player.direction = "up"
		player.animation_player.play("walk_" + player.direction)
			
	else:
		player.velocity = Vector2.ZERO
		ChangeState.emit(self, "idle")

