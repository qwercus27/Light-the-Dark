extends Path2D

@export var moving_speed = 50.0
@export var accel_rate = 0.6
@export var direction = 1
@export var end_percent = 0.15
@export var auto_start = false
@export var keep_going = true
@export var pauses = true
@export var pause_time = 2

var moving = false
var in_use = false
var paused = false
var speed
var stopping_speed = moving_speed * .1
var pr

# Called when the node enters the scene tree for the first time.
func _ready():
	$PauseTimer.wait_time = pause_time
	speed = stopping_speed
	pr = $PathFollow2D.progress_ratio
	if auto_start:
		moving = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
		
	if not keep_going and not in_use:
		if pr < 0.01:
			moving = false
			pr = 0
			
	pr = $PathFollow2D.progress_ratio
	
	if moving:
		$PathFollow2D.progress += delta * speed * direction
		
	if pr > 0.99 and moving and direction == 1:
		if pauses and not paused and $StartTimer.time_left == 0:
			pr = 1
			paused = true
			moving = false
			$PauseTimer.start()
		else:
			change_direction()
	if pr < 0.01 and moving and direction == -1:
		if pauses and not paused and $StartTimer.time_left == 0:
			pr = 0
			paused = true
			moving = false
			$PauseTimer.start()
		else:
			change_direction()
	
	if pr > 1 - end_percent and moving:
		if direction == 1:
			speed = move_toward(speed, stopping_speed, accel_rate)
		if direction == -1:
			speed = move_toward(speed, moving_speed, accel_rate)
	if pr < 0 + end_percent and moving:
		if direction == -1:
			speed = move_toward(speed, stopping_speed, accel_rate)
		if direction == 1:
			speed = move_toward(speed, moving_speed, accel_rate)

func change_direction():
	if pr > 0.99:
		direction = -1
	elif pr < 0.01:
		direction = 1

func _on_area_2d_area_entered(area):
	in_use = true
	if area.is_in_group("player_hurtbox"):

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
