extends PlayerState

func enter(msg := {}) -> void:
	player.animation.play("idle")

func physics_update(_delta: float) -> void:
	if not player.is_on_floor():
		state_machine.transition_to("Air")
	else:
		player.coyote.start()
		
		player.velocity.x = move_toward(player.velocity.x, 0, player.SPEED)
		player.velocity.z = move_toward(player.velocity.z, 0, player.SPEED)

	if Input.is_action_just_pressed("jump"):
		state_machine.transition_to("Air", {do_jump = true})
	elif player.get_input_direction() != Vector2.ZERO:
		state_machine.transition_to("Walk")
	elif Input.is_action_just_pressed("run"):
		state_machine.transition_to("Mach1")
