extends PlayerState

func enter(msg := {}) -> void:
	player.audio.stop()
	player.audio.stream = load("res://sounds/chargesuperjump.wav")
	player.audio.play()
	player.animation.play("crouch")

func physics_update(delta: float) -> void:
	if not player.is_on_floor():
		state_machine.transition_to("Air")
	else:
		player.coyote.start()
		
	if !player.audio.playing:
		player.audio.stream = load("res://sounds/superjumploop.wav")
		player.audio.play()	

	var input_dir = player.get_input_direction()
	var direction = (player.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		player.velocity.x = direction.x * 2
		player.velocity.z = direction.z * 2
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player.SPEED)
		player.velocity.z = move_toward(player.velocity.z, 0, player.SPEED)
	
	var multiplier = 1
	
	if player.mach == 3:
		multiplier = 1.2
	
	player.velocity.y -= player.gravity * delta
	
	player.move_and_slide()

	if Input.is_action_just_released("superjump"):
		player.audio.stop()
		player.audio.stream = load("res://sounds/superjumprelease.wav")
		player.audio.play()	
		player.velocity.y = 50 * multiplier
		state_machine.transition_to("Air", {superJump = true})
