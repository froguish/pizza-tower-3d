extends PlayerState

func enter(msg := {}) -> void:
	player.model.rotation.x -= deg_to_rad(90)
	if player.mach < 2:
		player.animation.play("run")

func physics_update(delta: float) -> void:
	player.camerabase.rotation.x = move_toward(player.camerabase.rotation.x, deg_to_rad(110), 0.05)
	
	if !player.audio.playing:
		match (player.mach):
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
	player.wallrun(1)
	
	if !player.is_on_wall():
		player.model.rotation.x = 0
		player.camerabase.rotation.x = 0
		
		player.velocity.y = 0
		player.velocity.x = player.velocityX
		player.velocity.z = player.velocityZ
		state_machine.transition_to("Air")
	elif Input.is_action_just_pressed("jump"):
		player.model.rotation.x = 0
		state_machine.transition_to("WallJump")
	elif Vector2(direction.x, direction.z) == Vector2.ZERO:
		player.model.rotation.x = 0
		player.camerabase.rotation.x = 0
		
		player.velocity = Vector3.ZERO
		player.mach = 0
		state_machine.transition_to("Air")
	elif !Input.is_action_pressed("run"):
		player.model.rotation.x = 0
		player.camerabase.rotation.x = 0
		
		player.velocity = Vector3.ZERO
		player.mach = 0
		state_machine.transition_to("Air")
