extends PlayerState

var input_dir
var direction

func enter(msg := {}) -> void:
	input_dir = player.get_input_direction()
	direction = (player.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	player.dashTimer.start()

func physics_update(delta: float) -> void:
	if not player.is_on_floor():
		state_machine.transition_to("Air")
	else:
		player.coyote.start()
	
	if !player.dashTimer.is_stopped():
		player.velocity.x = direction.x * player.SPEED * 8
		player.velocity.z = direction.z * player.SPEED * 8
		
		player.move_and_slide()
	elif Input.is_action_pressed("run"):
		state_machine.transition_to("Mach2")
	elif Vector2(player.direction.x, player.direction.z) == Vector2.ZERO:
		state_machine.transition_to("Idle")
	else:
		state_machine.transition_to("Walk")
	
	if Input.is_action_just_pressed("jump"):
		state_machine.transition_to("Air", {do_jump = true})
