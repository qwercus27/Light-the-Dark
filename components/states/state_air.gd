extends PlayerState


func enter(msg := {}) -> void:

	if msg.has("do_jump"):
		player.velocity.y = player.jump_v
		#player.get_node("JumpAudio").play(0.0)
	player.get_node("AnimatedSprite2D").play("jump")
	player.get_node("LandingAudio").volume_db = -12
	#print("entered air state")

func physics_update(delta: float) -> void:
	
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
	
	if(player.get_node("LandingAudio").volume_db < 0):
		player.get_node("LandingAudio").volume_db += 0.2
	
	
	if player.is_on_floor():
		if is_equal_approx(player.velocity.x, 0.0):
			player.get_node("LandingAudio").play()
			state_machine.transition_to("Idle")
		else:
			state_machine.transition_to("Run")
		

		
