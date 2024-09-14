extends PlayerState

var box
var box_pos
var box_rel_pos
var direction = 0
var right_clear = true
var left_clear = true
var fade_audio = false
var push_audio
var sprite
var initial_push_db

func enter(_msg := {}) -> void:

	#print("entered push state")
	sprite = player.get_node("AnimatedSprite2D")
	sprite.play("push")
	
	push_audio = player.get_node("PushAudio")
	initial_push_db = push_audio.volume_db
	push_audio.play()
	player.get_node("RunningAudio").stop()
	
	box = player.current_box
	box.hit_block.connect(on_hit_block)
	box.cleared_block.connect(on_cleared_block)
	box.hide_hint()
	box_pos = box.position.x
	
	
	if(box_pos*3 > player.position.x):
		box_rel_pos = 1
	else:
		box_rel_pos = -1

	box.shrink_collision_box(box_rel_pos)

func physics_update(delta: float) -> void:
	
	if not player.can_push:
		state_machine.transition_to("Idle")
		box.reset_collision_box(box_rel_pos)
		push_audio.stop()
		return
		
	if not player.is_on_floor():
		state_machine.transition_to("Air")
		box.reset_collision_box(box_rel_pos)
		push_audio.stop()
		return
	
	direction = Input.get_axis("left", "right")
	

	if direction:
		
		if (direction > 0 and right_clear) or (direction < 0 and left_clear):
			player.velocity.x = direction * player.push_speed
			sprite.play("push")
			push_audio.set_stream_paused(false)
			if(box.linear_velocity.y <= 0 or box.on_moving_platform):
				box.position.x = move_toward(box.position.x, player.position.x/3 + (box_rel_pos * 14), player.push_speed)
	else:
		
		player.velocity.x = move_toward(player.velocity.x, 0, player.push_speed)
		sprite.pause()
		fade_audio = true
	
	player.velocity.y += player.gravity * delta

	player.move_and_slide()
	
	
	if not Input.is_action_pressed("a"):

		box.show_hint()
		push_audio.stop()
		push_audio.volume_db = initial_push_db
		box.reset_collision_box(box_rel_pos)
		state_machine.transition_to("Idle")
		
	if fade_audio:
		push_audio.volume_db -= 0.8
		if push_audio.volume_db < -15:
			push_audio.set_stream_paused(true)
			#push_audio.seek(0)
			push_audio.volume_db = initial_push_db
			fade_audio = false


func on_hit_block():

	if direction > 0:
		right_clear = false
	if direction < 0:
		left_clear = false
	fade_audio = true
	print("push: hit block emitted")


func on_cleared_block():
	right_clear = true
	left_clear = true
	print("push: cleared block emitted")


