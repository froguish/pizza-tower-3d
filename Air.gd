extends PlayerState

var wasMach1 = false

func enter(msg := {}) -> void:
	if msg.has("do_jump"):
		player.velocity.y = player.JUMP_VELOCITY
		
	if player.mach == 1:
		player.mach = 0
		wasMach1 = true

func physics_update(delta: float) -> void:
	player.move(delta)
	
	if player.is_on_floor():
		if !player.buffer.is_stopped():
			player.velocity.y = player.JUMP_VELOCITY
			player.buffer.stop()
		elif player.get_input_direction() == Vector2.ZERO:
			state_machine.transition_to("Idle")
		elif player.mach == 2:
			state_machine.transition_to("Mach2")
		elif player.mach == 3:
			state_machine.transition_to("Mach3")
		elif wasMach1:
			state_machine.transition_to("Mach1")
		else:
			state_machine.transition_to("Walk")
	elif Input.is_action_just_pressed("jump"):
		if !player.coyote.is_stopped():
			player.velocity.y = player.JUMP_VELOCITY
		else:
			player.buffer.start()
