extends PlayerState

func enter(msg := {}) -> void:
	player.velocity.y = 10

func physics_update(delta: float) -> void:
	state_machine.transition_to("Air")
