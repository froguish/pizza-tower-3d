extends PlayerState

func physics_update(delta: float) -> void:
	var input_dir = player.get_input_direction()
	var direction = (player.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	player.wallrun(-1)
	
	if player.is_on_floor():
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
		state_machine.transition_to("WallJump", {goingDown = true})
	elif Vector2(direction.x, direction.z) == Vector2.ZERO:
		player.velocity = Vector3.ZERO
		player.mach = 0
		state_machine.transition_to("Air")
	elif !Input.is_action_pressed("run"):
		player.velocity = Vector3.ZERO
		player.mach = 0
		state_machine.transition_to("Air")
