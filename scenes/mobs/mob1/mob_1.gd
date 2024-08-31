extends CharacterBody2D


const SPEED = 50

var direction
var left_blocked = false
var right_blocked = false
var left_or_right = [-1, 1]

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	change_movement(left_or_right[randi_range(0,1)])
	z_index = 1
	
func _physics_process(delta):
	# Add the gravity.
	#print("left: " + str(left_blocked) + "right: " + str(right_blocked))
	if not is_on_floor():
		velocity.y += gravity * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	if is_zero_approx(velocity.x):
		if direction == 1:
			right_blocked = true
			change_movement(0)
			$MovementTimer.start(3)
		elif direction == -1:
			left_blocked = true
			change_movement(0)
			$MovementTimer.start(3)
	
func _on_movement_timer_timeout():
	if left_blocked:
		change_movement(1)
		left_blocked = false
	elif right_blocked:
		change_movement(-1)
		right_blocked = false
	else:
		change_movement(left_or_right[randi_range(0,1)])

func change_movement(dir : int):
	direction = dir

func _on_left_sensor_area_entered(area):
	if area.is_in_group("tile"):
		left_blocked = true
		change_movement(0)
		$MovementTimer.start(3)

func _on_left_sensor_area_exited(area):
	left_blocked = false
	
func _on_right_sensor_area_entered(area):
	if area.is_in_group("tile"):
		right_blocked = true
		change_movement(0)
		$MovementTimer.start(3)
	
func _on_right_sensor_area_exited(area):
	right_blocked = false

func _on_hitbox_area_entered(area):
	if area.is_in_group("player"):
		area.get_parent().get_hit()
