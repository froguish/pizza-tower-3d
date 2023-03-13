extends CharacterBody3D


const SPEED = 4
const JUMP_VELOCITY = 10

const H_CONTROL_SENS = 4
const V_CONTROL_SENS = 2

const MAX_SPEED = 40

var input_dir
var direction

var mach

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var camerabase = $CameraBase
@onready var coyote = $coyote
@onready var buffer = $buffer
@onready var Mach2 = $Mach2
@onready var Mach3 = $Mach3

func _ready():
	Input.mouse_mode = 2

func _input(event):
	if event is InputEventMouseMotion:
		camerabase.rotation.x -= deg_to_rad(event.relative.y * 1)
		camerabase.rotation.x = clamp(camerabase.rotation.x, deg_to_rad(-90), deg_to_rad(90))
		rotation.y -= deg_to_rad(event.relative.x * 1)

func _physics_process(_delta):
	if Input.is_action_pressed("look_right"):
		rotation.y -= deg_to_rad(H_CONTROL_SENS * 1)
	elif Input.is_action_pressed("look_left"):
		rotation.y -= deg_to_rad(-H_CONTROL_SENS * 1)
	elif Input.is_action_pressed("look_up"):
		camerabase.rotation.x -= deg_to_rad(-V_CONTROL_SENS * 1)
		camerabase.rotation.x = clamp(camerabase.rotation.x, deg_to_rad(-90), deg_to_rad(90))
	elif Input.is_action_pressed("look_down"):
		camerabase.rotation.x -= deg_to_rad(V_CONTROL_SENS * 1)
		camerabase.rotation.x = clamp(camerabase.rotation.x, deg_to_rad(-90), deg_to_rad(90))
	
func get_input_direction():
	return Input.get_vector("move_left", "move_right", "move_up", "move_down")

func move(delta):
	var multiplier = 1
	match (mach):
		2:
			multiplier = 9
		3:
			multiplier = 15
	input_dir = get_input_direction()
	direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		if mach == 1:
			velocity.x += direction.x * 0.3
			velocity.z += direction.z * 0.3
		else:
			velocity.x = direction.x * SPEED * multiplier
			velocity.z = direction.z * SPEED * multiplier
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	velocity.y -= gravity * delta
	
	#if mach == 1:
	#	velocity.x = clamp(velocity.x, -direction.x * MAX_SPEED, direction.x * MAX_SPEED)
	#	velocity.z = clamp(velocity.z, -direction.z * MAX_SPEED, direction.z * MAX_SPEED)
	
	move_and_slide()
	
	print(velocity)
	
