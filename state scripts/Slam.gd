extends PlayerState

func enter(msg := {}) -> void:
	player.audio.stop()
	player.audio.stream = load("res://sounds/groundpound start.wav")
	player.audio.play()
	player.animation.play("slam")
	player.velocity.y = 0

func physics_update(delta: float) -> void:
	player.velocity.y -= 100 * delta 
	player.move_and_slide()

	if player.is_on_floor():
		player.audio.stop()
		player.audio.stream = load("res://sounds/groundpound end.wav")
		player.audio.play()
		state_machine.transition_to("Idle")
