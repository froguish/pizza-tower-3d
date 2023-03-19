extends PlayerState


func enter(msg := {}) -> void:
	player.animation.play("run", -1, 3)
	
	player.mach = 3

func physics_update(delta: float) -> void:
	if not player.is_on_floor():
		player.audio.stop()
		state_machine.transition_to("Air")
	else:
		player.coyote.start()

	if !player.audio.playing and player.is_on_floor():
		player.audio.stream = load("res://sounds/mach3.wav")
		player.audio.play()

	player.move(delta)

	if player.mach == 2:
		player.audio.stop()
		state_machine.transition_to("Mach2")
	if Input.is_action_just_pressed("jump"):
		state_machine.transition_to("Air", {do_jump = true})
	elif !Input.is_action_pressed("run"):
		player.audio.stop()
		state_machine.transition_to("Walk")
	elif player.is_on_wall() and (player.get_floor_angle() < 1.3 and player.get_floor_angle() > 0):
		state_machine.transition_to("WallRun")
	elif Vector2(player.velocity.x, player.velocity.z) == Vector2.ZERO:
		player.audio.stop()
		state_machine.transition_to("Idle")
	elif Input.is_action_pressed("superjump"):
		player.audio.stop()
		state_machine.transition_to("SuperJump")
	elif Input.is_action_just_pressed("dash"):
		player.audio.stop()
		state_machine.transition_to("Dash")
