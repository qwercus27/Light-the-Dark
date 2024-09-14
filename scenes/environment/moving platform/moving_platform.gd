extends Path2D

@export var moving_speed = 50.0
@export var direction = 1
@export var auto_start = false
@export var keep_going = true
@export var pauses = true

var moving = false
var in_use = false
var paused = false
var speed
var stopping_speed = moving_speed * .1
var pr

# Called when the node enters the scene tree for the first time.
func _ready():
	speed = stopping_speed
	pr = $PathFollow2D.progress_ratio
	if auto_start:
		moving = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	#print("moving: " + str(moving) + " / Pause Timer: " + str($PauseTimer.time_left) + " / StartTimer: " + str($StartTimer.time_left))
	print("speed: " + str(speed))
	
	pr = $PathFollow2D.progress_ratio
	
	if moving:
		$PathFollow2D.progress += delta * speed * direction
		
	if pr > 0.99 and moving and direction == 1:
		if pauses and not paused and $StartTimer.time_left == 0:
			paused = true
			moving = false
			$PauseTimer.start()
		else:
			change_direction()
	if pr < 0.01 and moving and direction == -1:
		if pauses and not paused and $StartTimer.time_left == 0:
			paused = true
			moving = false
			$PauseTimer.start()
		else:
			change_direction()
	
	if pr > 0.925 and moving:
		if direction == 1:
			speed = move_toward(speed, stopping_speed, 1)
		if direction == -1:
			speed = move_toward(speed, moving_speed, 1)
	if pr < .075 and moving:
		if direction == -1:
			speed = move_toward(speed, stopping_speed, 1)
		if direction == 1:
			speed = move_toward(speed, moving_speed, 1)

func change_direction():
	if pr > 0.99:
		direction = -1
	elif pr < 0.01:
		direction = 1

func _on_area_2d_area_entered(area):
	in_use = true
	if area.is_in_group("player_hurtbox"):
		print("player on platform")
		if not auto_start:
			$PauseTimer.start(1)

func _on_area_2d_area_exited(area):
	if area.is_in_group("player_hurtbox"):
		in_use = false


func _on_pause_timer_timeout():
	change_direction()
	moving = true
	$StartTimer.start()
	paused = false
