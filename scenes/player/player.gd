class_name Player
extends CharacterBody2D

signal grabbed_ladder
signal released_ladder
signal grabbed_box
signal lit_torch
signal opened_door
signal hit

var speed = 200.0
var push_speed = 100.0
var ladder_speed = 150.0
var jump_v = -350.0
var can_push = false
var can_climb = false
var can_descend = false
var can_drop = false
var can_light = false
var can_open = false
var can_unlock = false
var current_one_way
var current_torch
var current_lock
var current_box

var key_count = 0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	scale = Vector2(3,3)
	$AnimatedSprite2D.modulate.a = 1.0
	$PointLight2D.energy = 1
	can_open = false
	key_count = 0
	$Interact.set_monitorable(true)
	$CollisionShape2D.disabled = false
	velocity.y = 0
	$RunningAudio.volume_db = -10
	$AnimatedSprite2D.stop()

func _physics_process(delta):
	
	if can_climb:

		if Input.is_action_pressed("up"):
			grabbed_ladder.emit()
	
	if can_push:
		if Input.is_action_just_pressed("a"):
			grabbed_box.emit()
			
	if can_drop:
		if Input.is_action_just_pressed("down"):
			current_one_way.pass_through_platform()
			#position.y += 3
			grabbed_ladder.emit()
			
	if can_light:
		if Input.is_action_just_pressed("a"):
			current_torch.interact()
			lit_torch.emit()
			can_light = false
	
	if can_open:
		if Input.is_action_just_pressed("a") or Input.is_action_just_pressed("up"):
			opened_door.emit()
	
	if key_count > 0 and can_unlock:
		if Input.is_action_just_pressed("a"):
			current_lock.unlock()
			key_count -= 1
	#if not is_on_floor():
		#if(can_drop == true):
			#print("cannot drop")
		#can_drop = false
		


func _on_interact_area_entered(area):
	
	if area.is_in_group("ladder"):
		can_climb = true
	if area.is_in_group("one_way_platform"):
		can_drop = true
		current_one_way = area.get_parent()
	if area.is_in_group("torch"):
		current_torch = area.get_parent()
		if not current_torch.get_node("Lights").visible:
			can_light = true
	if area.is_in_group("box"):
		can_push = true
		current_box = area.get_parent()
	if area.is_in_group("door"):
		can_open = true
	if area.is_in_group("key"):
		key_count += 1
	if area.is_in_group("lock"):
		current_lock = area.get_parent()
		can_unlock = true

func _on_interact_area_exited(area):
	if area.is_in_group("ladder"):
		var areas = $Interact.get_overlapping_areas()
		var a_count = 0
		for a in areas:
			if a.is_in_group("ladder"):
				a_count += 1
		if a_count == 0:
			can_climb = false
			released_ladder.emit()
	if area.is_in_group("one_way_platform"):
		can_drop = false
	if area.is_in_group("torch"):
		can_light = false
	if area.is_in_group("door"):
		can_open = false
	if area.is_in_group("lock"):
		can_unlock = false
	if area.is_in_group("box"):
		can_push = false
		
func exit(x_pos):
	$StateMachine.transition_to("Exit", {door_x = x_pos})

func get_hit():
	print("got hit")
	$StateMachine.transition_to("Die")
	$HitAudio.play()
	hit.emit()
	
func toggle_collision():
	$CollisionShape2D.disabled = not $CollisionShape2D.disabled
	print("Player collision " + str($CollisionShape2D.disabled))
