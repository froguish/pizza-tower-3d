extends PlayerState

func enter(msg := {}) -> void:
	player.mach = 0

func physics_update(delta: float) -> void:
	if not player.is_on_floor():
		state_machine.transition_to("Air")
		return
	else:
		player.coyote.start()

	player.move(delta)

	if Input.is_action_just_pressed("jump"):
		state_machine.transition_to("Air", {do_jump = true})
	elif player.get_input_direction() == Vector2.ZERO:
		state_machine.transition_to("Idle")
	elif Input.is_action_just_pressed("run"):
		state_machine.transition_to("Mach1")
