extends Node2D

@export var curve : Curve2D
# Called when the node enters the scene tree for the first time.
func _ready():
	$Path2D.curve = curve
	$Path2D.curve.add_point()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
