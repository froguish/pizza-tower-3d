extends PlayerState

func physics_update(delta: float) -> void:
	player.move(delta)
	player.wallrun()
	
	if !player.is_on_wall_only():
		player.velocity.y = 0
		match (player.mach):
			0:
				state_machine.transition_to("Walk")
			1:
				state_machine.transition_to("Mach1")
			2:
				state_machine.transition_to("Mach2")
			3:
				state_machine.transition_to("Mach3")
	elif Input.is_action_just_pressed("jump"):
		state_machine.transition_to("WallJump")
	elif Vector2(player.velocity.x, player.velocity.z) == Vector2.ZERO:
		state_machine.transition_to("Air")
	elif !Input.is_action_pressed("run"):
		player.velocity = Vector3.ZERO
		player.mach = 0
		state_machine.transition_to("Air")
