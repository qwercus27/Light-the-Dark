extends PlayerState


func enter(_msg := {}) -> void:

	player.velocity.x = 0
	player.get_node("AnimatedSprite2D").play("idle")
	
	
func update(delta: float) -> void:
		
	if not player.is_on_floor():
		state_machine.transition_to("Air")
		return
	
	player.velocity.y += player.gravity * delta
	
	player.move_and_slide()
	
	if Input.is_action_just_pressed("down"):
		state_machine.transition_to("Crouch")
	if Input.is_action_just_pressed("space"):
		state_machine.transition_to("Air", {do_jump = true})
	elif Input.is_action_pressed("left") or Input.is_action_pressed("right"):
		state_machine.transition_to("Run")
		

		

