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
		elif Vector2(player.velocity.x, player.velocity.z) == Vector2.ZERO:
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
	elif player.is_on_wall_only() and (player.mach > 0 or wasMach1):
		wasMach1 = false
		state_machine.transition_to("WallRun")
	elif Input.is_action_pressed("run") and player.checkWall.is_colliding() and player.velocity.y == -0.75:
		state_machine.transition_to("WallDown")
	elif Input.is_action_pressed("slam"):
		state_machine.transition_to("Slam")
	elif Input.is_action_just_pressed("superjump"):
		state_machine.transition_to("Uppercut")
