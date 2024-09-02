extends StaticBody2D

signal hit_block
signal cleared_block

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var velocity = 0.0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func show_hint():
	$InteractHint.visible = true
	
	
func hide_hint():
	$InteractHint.visible = false


func _on_interact_area_entered(area):
	if area.is_in_group("player"):
		show_hint()
	if area.get_parent() is StaticBody2D:
		hit_block.emit()
		
func _on_interact_area_exited(area):
	if area.is_in_group("player"):
		hide_hint()
	if area.get_parent() is StaticBody2D:
		cleared_block.emit()
