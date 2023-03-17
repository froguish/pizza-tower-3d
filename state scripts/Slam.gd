extends PlayerState

func enter(msg := {}) -> void:
	player.velocity.y = 0

func physics_update(delta: float) -> void:
	player.velocity.y -= 100 * delta 
	player.move_and_slide()

	if player.is_on_floor():
		state_machine.transition_to("Idle")
