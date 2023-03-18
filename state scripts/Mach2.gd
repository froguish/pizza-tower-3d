extends PlayerState


func enter(msg := {}) -> void:
	player.animation.play("run", -1, 2)
	
	player.mach = 2
	player.Mach3.start()

func physics_update(delta: float) -> void:
	if not player.is_on_floor():
		state_machine.transition_to("Air")
	else:
		player.coyote.start()
		
	if !player.audio.playing:
		player.audio.stream = load("res://sounds/mach2.wav")
		player.audio.play()	
	
	player.move(delta)

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
	elif player.Mach3.is_stopped() and (abs(player.velocity.x) > 34 or abs(player.velocity.z) > 34):
		player.audio.stop()
		state_machine.transition_to("Mach3")
	elif Input.is_action_pressed("superjump"):
		player.audio.stop()
		state_machine.transition_to("SuperJump")
	elif Input.is_action_just_pressed("dash"):
		player.audio.stop()
		state_machine.transition_to("Dash")
