extends PlayerState

func enter(_msg := {}) -> void:
	#print("entered run state")
	player.get_node("AnimatedSprite2D").play("run")
	player.get_node("RunningAudio").play()

func physics_update(delta: float) -> void:
	
	if not player.is_on_floor():
		state_machine.transition_to("Air")
		player.get_node("RunningAudio").set_stream_paused(true)
		return
	
	var direction = Input.get_axis("left", "right")

	if direction:
		player.velocity.x = direction * player.speed
		if direction > 0:
			player.get_node("AnimatedSprite2D").set_flip_h(false)
		elif direction < 0:
			player.get_node("AnimatedSprite2D").set_flip_h(true)
			
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player.speed)
	
	player.velocity.y += player.gravity * delta


	player.move_and_slide()
	
	if Input.is_action_just_pressed("space"):
		player.get_node("RunningAudio").set_stream_paused(true)
		state_machine.transition_to("Air", {do_jump = true})
#	elif Input.is_action_just_pressed("Down"):
#		state_machine.transition_to("Slide", {dir = direction})
	elif is_equal_approx(direction, 0.0):
		state_machine.transition_to("Idle")
		player.get_node("RunningAudio").set_stream_paused(true)
		


		

