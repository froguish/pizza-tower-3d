extends Control

@onready var label = get_node("VBoxContainer/Label2")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_label_pressed():
	hide()
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
