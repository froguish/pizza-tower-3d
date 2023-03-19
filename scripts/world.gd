extends Node3D

@onready var pillarJohn = $"Pillar John"
@onready var music = $music
@onready var exit = $exit
@onready var pizzaTime = $pizzaTime
@onready var time = $time

var pizzaTimed = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if pizzaTimed:
		time.set_text(str(pizzaTime.time_left).pad_decimals(3))
		if pizzaTime.is_stopped():
			get_tree().change_scene_to_file("res://scenes/lose.tscn")

func _on_pillar_john_body_entered(body):
	if !pizzaTimed:
		pizzaTimed = true
		pizzaTime.start()
		pillarJohn.hide()
		exit.show()
		music.stream = load("res://music/pizza time.mp3")
		music.play()


func _on_exit_body_entered(body):
	if pizzaTimed and !pizzaTime.is_stopped():
		get_tree().change_scene_to_file("res://scenes/win.tscn")
