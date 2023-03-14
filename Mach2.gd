extends PlayerState

func enter(msg := {}) -> void:
	player.mach = 2
	player.Mach3.start()

func physics_update(delta: float) -> void:
	if not player.is_on_floor():
		state_machine.transition_to("Air")
	else:
		player.coyote.start()

	player.move(delta)

	if Input.is_action_just_pressed("jump"):
		state_machine.transition_to("Air", {do_jump = true})
	elif !Input.is_action_pressed("run"):
		state_machine.transition_to("Walk")
	elif Vector2(player.velocity.x, player.velocity.z) == Vector2.ZERO:
		state_machine.transition_to("Idle")
	elif player.Mach3.is_stopped():
		state_machine.transition_to("Mach3")
