extends RigidBody2D

signal hit_block
signal cleared_block

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var scaled_items = [$Sprite2D, $CollisionShape2D, $Interact, $InteractHint]
var new_scale = Vector2(3,3)
var on_moving_platform = false

# Called when the node enters the scene tree for the first time.
func _ready():
	lock_rotation = true
	$Sprite2D.scale = new_scale
	$CollisionShape2D.scale = new_scale
	$Interact.scale = new_scale
	$InteractHint.scale = new_scale
	$InteractHint.position = $InteractHint.position * new_scale
	#freeze_mode = 1
	freeze = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if linear_velocity.y != 0:
		hide_hint()
	

	
func show_hint():
	$InteractHint.visible = true
	
	
func hide_hint():
	$InteractHint.visible = false


func _on_interact_area_entered(area):
	if area.is_in_group("player"):
		show_hint()
	if area.get_parent() is StaticBody2D:
		if not area.is_in_group("floor switch") and not area.is_in_group("moving platform"):
			hit_block.emit()
			print("block hit something")
	if area.is_in_group("ladder"):
		print("box interacting with ladder")
		freeze = true
	if area.is_in_group("moving platform"):
		on_moving_platform = true

		
func _on_interact_area_exited(area):
	if area.is_in_group("player"):
		hide_hint()
	if area.get_parent() is StaticBody2D:
		cleared_block.emit()
	if area.is_in_group("ladder"):
		freeze = false
	if area.is_in_group("moving platform"):
		on_moving_platform = false
		
func shrink_collision_box(rel_pos):
	$CollisionShape2D.scale.x = 3.0 * 0.9
	#$CollisionShape2D.position.x += rel_pos * 1
	
func reset_collision_box(rel_pos):
	$CollisionShape2D.scale.x = 3.0
	#$CollisionShape2D.position.x -= rel_pos * 1
