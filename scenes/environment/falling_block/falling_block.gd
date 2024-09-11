extends RigidBody2D

var new_scale = Vector2(3,3)
var initial_pos

# Called when the node enters the scene tree for the first time.
func _ready():
	initial_pos = position
	gravity_scale = 0
	$Sprite2D.scale = new_scale
	$CollisionShape2D.scale = new_scale
	$Interact.scale = new_scale
	lock_rotation = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_interact_area_entered(area):
	if area.is_in_group("player_hurtbox"):
		$FallTimer.start()


func _on_timer_timeout():

	gravity_scale = 1
	$ResetTimer.start()
	



func _on_reset_timer_timeout():
	gravity_scale = 0
	linear_velocity = Vector2(0,0)
	position = initial_pos
