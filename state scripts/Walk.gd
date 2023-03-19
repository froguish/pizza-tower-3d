extends PlayerState

func enter(msg := {}) -> void:
	player.animation.play("walk")
	
	player.mach = 0

func physics_update(delta: float) -> void:
	if not player.is_on_floor():
		state_machine.transition_to("Air")
	else:
		player.coyote.start()

	if !player.audio.playing:
		player.audio.stream = load("res://sounds/step.wav")
		player.audio.play()

	player.move(delta)

	if Input.is_action_just_pressed("jump"):
		state_machine.transition_to("Air", {do_jump = true})
	elif player.get_input_direction() == Vector2.ZERO:
		state_machine.transition_to("Idle")
	elif Input.is_action_just_pressed("run"):
		state_machine.transition_to("Mach1")
	elif Input.is_action_just_pressed("dash"):
		state_machine.transition_to("Dash")
