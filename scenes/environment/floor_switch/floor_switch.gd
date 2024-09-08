extends Node2D

#@export var switch_id : int
var area_count = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if area_count > 0:
		descend(delta)
	else:
		ascend(delta)


func _on_interact_area_area_entered(area):
	area_count += 1
	print("switch area entered")

func _on_interact_area_area_exited(area):
	area_count -= 1
	print("switch area exited")
	
func descend(delta):
	$TopBody.position.y = move_toward($TopBody.position.y, $BaseSprite.position.y + 1.5, delta * 4)
	
func ascend(delta):
	$TopBody.position.y = move_toward($TopBody.position.y, $BaseSprite.position.y - 0.5, delta * 4)
