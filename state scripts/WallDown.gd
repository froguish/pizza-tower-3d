extends PlayerState

func enter(msg := {}) -> void:
	match (player.mach):
		0:
			player.animation.play("run")
		1:
			player.animation.play("run")
		2:
			player.animation.play("run", -1, 2)
		3:
			player.animation.play("run", -1, 3)
	
	#player.position.x = player.position.x + 0.7 * (player.direction.x / player.direction.x) * -1
	#player.position.z = player.position.z + 0.7 * (player.direction.z / player.direction.z) * -1
	
	player.model.rotation.x += deg_to_rad(90)

func physics_update(delta: float) -> void:
	player.Camera.rotation.x = move_toward(player.Camera.rotation.x, deg_to_rad(-60), 0.05)
	
	if !player.audio.playing:
		match (player.mach):
			0:
				player.audio.stream = load("res://sounds/mach1.wav")
				player.audio.play()
			1:
				player.audio.stream = load("res://sounds/mach1.wav")
				player.audio.play()
			2:
				player.audio.stream = load("res://sounds/mach2.wav")
				player.audio.play()
			3:
				player.audio.stream = load("res://sounds/mach3.wav")
				player.audio.play()
	
	var input_dir = player.get_input_direction()
	var direction = (player.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	player.wallrun(-1, delta)
	
	if player.is_on_floor():
		player.model.rotation.x = 0
		player.Camera.rotation.x = 0
		
		player.velocity.y = 0
		player.velocity.x = player.velocityX
		player.velocity.z = player.velocityZ
		match (player.mach):
			0:
				state_machine.transition_to("Mach1")
			1:
				state_machine.transition_to("Mach1")
			2:
				state_machine.transition_to("Mach2")
			3:
				state_machine.transition_to("Mach3")
	elif Input.is_action_just_pressed("jump"):
		player.model.rotation.x = 0
		player.Camera.rotation.x = 0
		
		state_machine.transition_to("WallJump", {goingDown = true})
	elif Vector2(direction.x, direction.z) == Vector2.ZERO:
		player.model.rotation.x = 0
		player.Camera.rotation.x = 0
		
		player.animation.play("fall")
		player.audio.stop()
		player.velocity = Vector3.ZERO
		player.mach = 0
		state_machine.transition_to("Air")
	elif !Input.is_action_pressed("run"):
		player.model.rotation.x = 0
		player.Camera.rotation.x = 0
		
		player.animation.play("fall")
		player.audio.stop()
		player.velocity = Vector3.ZERO
		player.mach = 0
		state_machine.transition_to("Air")
