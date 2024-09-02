extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

func _on_interact_area_area_entered(area):
	if area.is_in_group("player"):
		visible = false
		$KeyAudio.play()


func _on_key_audio_finished():
	queue_free()
