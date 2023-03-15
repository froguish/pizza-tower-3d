extends PlayerState

func enter(msg := {}) -> void:
	player.velocity.y = 10

func physics_update(delta: float) -> void:
	player.move(delta)
	
	if player.is_on_floor():
		if Vector2(player.direction.x, player.direction.z) == Vector2.ZERO:
			state_machine.transition_to("Idle")
		else:
			state_machine.transition_to("Walk")
