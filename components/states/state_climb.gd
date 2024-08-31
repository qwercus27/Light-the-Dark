extends PlayerState

func enter(_msg := {}) -> void:
	player.released_ladder.connect(on_released_ladder)
	
	player.get_node("RunningAudio").stop()
	player.get_node("ClimbingAudio").play()

func physics_update(delta: float) -> void:
	
	if not player.can_climb and not player.can_drop:
		player.get_node("ClimbingAudio").stop()
		state_machine.transition_to("Idle")
		return
		
	#if player.is_on_floor() and not player.can_climb and not player.can_drop:
		#state_machine.transition_to("Idle")
		#return
	
	var direction = Input.get_axis("left", "right")

	if direction:
		player.velocity.x = direction * player.speed
		if direction > 0:
			player.get_node("AnimatedSprite2D").set_flip_h(false)
		elif direction < 0:
			player.get_node("AnimatedSprite2D").set_flip_h(true)
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player.speed)
	
	var y_direction = Input.get_axis("up", "down")
	
	if y_direction:
		player.get_node("AnimatedSprite2D").play("climb")
		player.velocity.y = y_direction * player.ladder_speed
		player.get_node("ClimbingAudio").set_stream_paused(false)
	else:
		player.get_node("AnimatedSprite2D").pause()
		player.velocity.y = move_toward(player.velocity.y, 0, player.ladder_speed)
		player.get_node("ClimbingAudio").set_stream_paused(true)
	#player.velocity.y += player.gravity * delta

	player.move_and_slide()
	
	#if Input.is_action_just_pressed("space"):
	#	state_machine.transition_to("Air", {do_jump = true})

func on_released_ladder():
	if(not player.is_on_floor()):
		player.get_node("ClimbingAudio").stop()
		state_machine.transition_to("Air")
	else:
		player.get_node("ClimbingAudio").stop()
		state_machine.transition_to("Run")

