extends CharacterBody3D


const SPEED = 6
const JUMP_VELOCITY = 10

const H_CONTROL_SENS = 2.5
const V_CONTROL_SENS = 2

const MAX_SPEED = SPEED
var maximumSpeed

var input_dir
var direction

var mach = 0

var velocityX
var velocityZ

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var coyote = $coyote
@onready var buffer = $buffer
@onready var Mach2 = $Mach2
@onready var Mach3 = $Mach3
@onready var checkWall = $checkWall
@onready var upWall = $upWall
@onready var dashTimer = $dash
@onready var animation = get_node("peppino full/AnimPlayer")
@onready var model = $"peppino full"
@onready var audio = $sfx
@onready var camerabase = get_node("Camera/CameraBase")
@onready var Camera = $Camera

func _ready():
	#Input.mouse_mode = 2
	pass

func _physics_process(_delta):
	var cameraInput = Input.get_vector("look_left", "look_right", "look_up", "look_down", 0.2)
	
	rotation.y -= deg_to_rad(cameraInput.x * 2)
	camerabase.rotation.x -= deg_to_rad(cameraInput.y * 1.5)
	camerabase.rotation.x = clamp(camerabase.rotation.x, deg_to_rad(-60), deg_to_rad(60))
	
func get_input_direction():
	return Input.get_vector("move_left", "move_right", "move_up", "move_down", 0.5)

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
			maximumSpeed = 39
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
					velocity.x = velocity.x * 0.8 + direction.x
					velocity.z = velocity.z * 0.8 + direction.z
				3:
					velocity.x = velocity.x * 0.9 + direction.x
					velocity.z = velocity.z * 0.9 + direction.z
					mach = 2
		velocity.x = move_toward(velocity.x, direction.x * maximumSpeed, multiplier)
		velocity.z = move_toward(velocity.z, direction.z * maximumSpeed, multiplier)
	else:
		velocity.x = move_toward(velocity.x, 0, 1)
		velocity.z = move_toward(velocity.z, 0, 1)
	
	velocity.y -= gravity * delta
	
	velocityX = velocity.x
	velocityZ = velocity.z
	
	move_and_slide()
		
	#print(velocity)
	#print(get_floor_angle())

func wallrun(direction, delta):
	velocity.x = 0
	velocity.z = 0
	if abs(velocityX) > abs(velocityZ):
		velocity.y = abs(velocityX) * direction
	else:
		velocity.y = abs(velocityZ) * direction
	
	if direction == -1:
		velocity.y -= gravity
	
	move_and_slide()
