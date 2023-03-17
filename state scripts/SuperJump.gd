extends PlayerState

func physics_update(delta: float) -> void:
	if not player.is_on_floor():
		state_machine.transition_to("Air")
	else:
		player.coyote.start()

	var input_dir = player.get_input_direction()
	var direction = (player.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		player.velocity.x = direction.x * 2
		player.velocity.z = direction.z * 2
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player.SPEED)
		player.velocity.z = move_toward(player.velocity.z, 0, player.SPEED)
	
	player.velocity.y -= player.gravity * delta
	
	player.move_and_slide()

	if Input.is_action_just_released("superjump"):
		player.velocity.y = 50
		state_machine.transition_to("Air")
