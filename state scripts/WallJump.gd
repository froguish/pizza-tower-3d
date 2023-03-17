extends PlayerState

var goingDown = -1

func enter(msg := {}) -> void:
	if msg.has("goingDown"):
		goingDown = 1
	else:
		goingDown = -1
	player.velocity.y = player.JUMP_VELOCITY
	player.move_and_slide()

func physics_update(delta: float) -> void:
	player.velocity.x = player.direction.x * player.SPEED * goingDown
	player.velocity.z = player.direction.z * player.SPEED * goingDown
	player.velocity.y -= player.gravity * delta
	player.move_and_slide()
	
	if player.is_on_floor():
		match (player.mach):
			0:
				state_machine.transition_to("Walk")
			1:
				state_machine.transition_to("Mach1")
			2:
				state_machine.transition_to("Mach2")
			3:
				state_machine.transition_to("Mach3")
