extends Node3D

@onready var player = $player

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player.position.y < -20:
		player.position = Vector3(0, 5, 0)
