extends PlayerState

var p_area
var p_initial_pos
var player_initial_pos

func enter(_msg := {}) -> void:
	#print("entered platform run state")
	
	p_area = _msg.get("p_area")
	p_initial_pos = p_area.global_position
	player_initial_pos = player.position
	player.get_node("AnimatedSprite2D").play("run")
	player.get_node("RunningAudio").play()

func physics_update(delta: float) -> void:
	
	if not player.is_on_floor() and not player.platform_area:
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
	
	#player.velocity.y += player.gravity * delta

	player.move_and_slide()
	if not player.platform_area:
		state_machine.transition_to("Run")
	if Input.is_action_just_pressed("space"):
		player.get_node("RunningAudio").set_stream_paused(true)
		state_machine.transition_to("Air", {do_jump = true})
#	elif Input.is_action_just_pressed("Down"):
#		state_machine.transition_to("Slide", {dir = direction})
	elif is_equal_approx(direction, 0.0):
		state_machine.transition_to("Platform Idle", {p_area = p_area})
		player.get_node("RunningAudio").set_stream_paused(true)
		


		

