extends Node

var fade_in = true
var fade_out = false
# Called when the node enters the scene tree for the first time.
func _ready():
	$Graphics.modulate.a = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	if fade_in:
		if $Graphics.modulate.a < 1:
			$Graphics.modulate.a += .01
	else:
		
		if $Graphics.modulate.a > 0:
			$Graphics.modulate.a -= .01
		else:
			await get_tree().create_timer(1).timeout
			get_tree().change_scene_to_file("res://scenes/start_menu.tscn")

func _on_timer_timeout():
	fade_in = false
