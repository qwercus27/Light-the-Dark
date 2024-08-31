extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$InteractHint.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func unlock():
	visible = false
	$LockAudio.play()
	$CollisionShape2D.disabled = true

func show_hint():
	$InteractHint.visible = true
	
	
func hide_hint():
	$InteractHint.visible = false
	
	
func _on_interact_area_entered(area):
	if area.is_in_group("player"):
		show_hint()


func _on_interact_area_exited(area):
	if area.is_in_group("player"):
		hide_hint()
