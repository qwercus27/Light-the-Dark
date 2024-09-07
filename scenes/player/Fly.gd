extends PlayerState

func enter(_msg := {}) -> void:
	#print("entered run state")
	player.get_node("AnimatedSprite2D").play("run")
	#player.gravity = 0

func physics_update(delta: float) -> void:
	
	
	var direction = Input.get_axis("left", "right")
	var direction_y = Input.get_axis("up", "down")

	if direction:
		player.velocity.x = direction * player.speed * 2
		if direction > 0:
			player.get_node("AnimatedSprite2D").set_flip_h(false)
		elif direction < 0:
			player.get_node("AnimatedSprite2D").set_flip_h(true)
			
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player.speed * 2)
	
	if direction_y:
		player.velocity.y = direction_y * player.speed * 2
	else:
		player.velocity.y = move_toward(player.velocity.y, 0, player.speed * 2)

	player.move_and_slide()
