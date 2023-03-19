extends PlayerState

func enter(msg := {}) -> void:
	if msg.has("superJump"):
		player.animation.play("fall")
	elif player.velocity.y < 0:
		player.animation.play("fall")
	elif player.mach == 2:
		player.animation.play("run", -1, 2)
	elif player.mach == 3:
		player.animation.play("run", -1, 3)
	
	if msg.has("do_jump"):
		player.velocity.y = player.JUMP_VELOCITY
		if player.mach < 2:
			player.audio.stream = load("res://sounds/jump.wav")
			player.audio.play()
			player.animation.play("jump", -1, 1.4)
	
func physics_update(delta: float) -> void:
	if !player.audio.playing:
		if player.animation.get_current_animation() != "fall":
			match (player.mach):
				1:
					player.audio.stream = load("res://sounds/mach1.wav")
					player.audio.play()
				2:
					player.audio.stream = load("res://sounds/mach2.wav")
					player.audio.play()
				3:
					player.audio.stream = load("res://sounds/mach3.wav")
					player.audio.play()
	
	player.move(delta)
	
	if player.is_on_floor():
		if !player.buffer.is_stopped():
			player.buffer.stop()
			state_machine.transition_to("Air", {do_jump = true})
		elif Vector2(player.velocity.x, player.velocity.z) == Vector2.ZERO:
			state_machine.transition_to("Idle")
		elif player.mach == 2:
			state_machine.transition_to("Mach2")
		elif player.mach == 3:
			state_machine.transition_to("Mach3")
		elif Input.is_action_pressed("run"):
			state_machine.transition_to("Mach1")
		else:
			state_machine.transition_to("Walk")
	elif Input.is_action_just_pressed("jump"):
		if !player.coyote.is_stopped():
			player.velocity.y = player.JUMP_VELOCITY
		else:
			player.buffer.start()
	elif player.is_on_wall_only() and (player.mach > 0 or Input.is_action_pressed("run")) and player.upWall.is_colliding():
		state_machine.transition_to("WallRun")
	elif Input.is_action_pressed("run") and player.checkWall.is_colliding() and player.velocity.y == -0.75:
		state_machine.transition_to("WallDown")
	elif Input.is_action_pressed("slam"):
		state_machine.transition_to("Slam")
	elif Input.is_action_just_pressed("superjump"):
		state_machine.transition_to("Uppercut")
