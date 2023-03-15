extends CharacterBody3D


const SPEED = 4
const JUMP_VELOCITY = 10

const H_CONTROL_SENS = 4
const V_CONTROL_SENS = 2

const MAX_SPEED = 4
var maximumSpeed

var input_dir
var direction

var mach = 0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var camerabase = $CameraBase
@onready var coyote = $coyote
@onready var buffer = $buffer
@onready var Mach2 = $Mach2
@onready var Mach3 = $Mach3
@onready var checkWall = $checkWall
@onready var dashTimer = $dash

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
		0:
			maximumSpeed = MAX_SPEED
			multiplier = SPEED
		1:
			maximumSpeed = 30
			multiplier = 0.3
		2:
			maximumSpeed = 35
			multiplier = 0.5
		3:
			maximumSpeed = 37
			multiplier = 0.6
	input_dir = get_input_direction()
	direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		if direction.dot(velocity.normalized()) < 0.1 and direction.dot(velocity.normalized()) > -0.1:
			match (mach):
				1:
					velocity.x = velocity.x * 0.6 + direction.x * 2
					velocity.z = velocity.z * 0.6 + direction.z * 2
				2:
					velocity.x = velocity.x * 0.65 + direction.x * 2
					velocity.z = velocity.z * 0.65 + direction.z * 2
				3:
					velocity.x = velocity.x * 0.7 + direction.x * 2
					velocity.z = velocity.z * 0.7 + direction.z * 2
		elif direction.dot(velocity.normalized()) < -0.9:
			match (mach):
				1:
					velocity.x = velocity.x * 0.1 + direction.x * 2
					velocity.z = velocity.z * 0.1 + direction.z * 2
				2:
					velocity.x = velocity.x * 0.3 + direction.x * 2
					velocity.z = velocity.z * 0.3 + direction.z * 2
				3:
					velocity.x = velocity.x * 0.35 + direction.x * 2
					velocity.z = velocity.z * 0.35 + direction.z * 2
					mach = 2
		velocity.x += direction.x * multiplier
		velocity.z += direction.z * multiplier
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	velocity.y -= gravity * delta
	
	move_and_slide()
	
	velocity.x = clamp(velocity.x, -(maximumSpeed + abs(direction.x)), (maximumSpeed + abs(direction.z)))
	velocity.z = clamp(velocity.z, -(maximumSpeed + abs(direction.z)), (maximumSpeed + abs(direction.z)))
	
	print(velocity)
	#print(get_floor_angle())

func wallrun(direction):
	velocity.x = 0
	velocity.z = 0
	var multiplier = 1
	match (mach):
		2:
			multiplier = 9
		3:
			multiplier = 15
	velocity.y = SPEED * multiplier * direction
	
	move_and_slide()
