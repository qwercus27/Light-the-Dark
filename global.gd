extends Node

var current_level

# Called when the node enters the scene tree for the first time.
func _ready():
	current_level = load("res://scenes/levels/level_1.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
