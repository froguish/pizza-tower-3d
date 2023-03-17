extends PlayerState

var velocityX
var velocityZ

func enter(msg := {}) -> void:
	player.mach = 1
	player.Mach2.start()

func physics_update(delta: float) -> void:
	if not player.is_on_floor():
		state_machine.transition_to("Air")
	else:
		player.coyote.start()

	velocityX = player.velocity.x
	velocityZ = player.velocity.z
	player.move(delta)

	if Input.is_action_just_pressed("jump"):
		state_machine.transition_to("Air", {do_jump = true})
	elif !Input.is_action_pressed("run"):
		state_machine.transition_to("Walk")
	elif player.is_on_wall() and (player.get_floor_angle() < 1.3 and player.get_floor_angle() > 0):
		state_machine.transition_to("WallRun", {PlayervelocityX = velocityX, PlayervelocityZ = velocityZ})
	elif Vector2(player.velocity.x, player.velocity.z) == Vector2.ZERO and !Input.is_action_pressed("run"):
		state_machine.transition_to("Idle")
	elif (abs(player.velocity.x) > 29 or abs(player.velocity.z) > 29):
		state_machine.transition_to("Mach2")
	elif Input.is_action_just_pressed("dash"):
		state_machine.transition_to("Dash")
