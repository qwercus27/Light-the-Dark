extends Node2D

var speed = 50
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Center.rotation_degrees += speed * delta
	
	$Platform1.global_position = $Center/Point1.global_position
	$Platform2.global_position = $Center/Point2.global_position
	$Platform3.global_position = $Center/Point3.global_position
	$Platform4.global_position = $Center/Point4.global_position
