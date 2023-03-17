extends PlayerState

func physics_update(delta: float) -> void:
	var input_dir = player.get_input_direction()
	var direction = (player.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	player.wallrun(1)
	
	if !player.is_on_wall():
		player.velocity.y = 0
		player.velocity.x = player.velocityX
		player.velocity.z = player.velocityZ
		state_machine.transition_to("Air")
	elif Input.is_action_just_pressed("jump"):
		state_machine.transition_to("WallJump")
	elif Vector2(direction.x, direction.z) == Vector2.ZERO:
		print()
		player.velocity = Vector3.ZERO
		player.mach = 0
		state_machine.transition_to("Air")
	elif !Input.is_action_pressed("run"):
		player.velocity = Vector3.ZERO
		player.mach = 0
		state_machine.transition_to("Air")
