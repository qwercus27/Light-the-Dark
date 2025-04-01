extends PlayerState

var p_area
var	p_initial_pos 
var	player_initial_pos

func enter(_msg := {}) -> void:
	#print("entered platform idle state")
	
	p_area = _msg.get("p_area")
	p_initial_pos = p_area.global_position
	player_initial_pos = player.position
	player.velocity.x = 0
	player.get_node("AnimatedSprite2D").play("idle")
	
	
func update(delta: float) -> void:
		
	if not player.is_on_floor():
		if not player.platform_area:
			state_machine.transition_to("Air")
			return
	
	#player.velocity.y += player.gravity * delta

	var platform_shift = p_area.global_position - p_initial_pos
	player.position.x += platform_shift.x
	p_initial_pos = p_area.global_position	
	player.position.y = move_toward(player.position.y, p_area.global_position.y - 36, player.speed)
	
	if Input.is_action_just_pressed("down"):
		state_machine.transition_to("Crouch")
	if Input.is_action_just_pressed("space"):
		state_machine.transition_to("Air", {do_jump = true})
	elif Input.is_action_pressed("left") or Input.is_action_pressed("right"):
		state_machine.transition_to("Platform Run", {p_area = p_area})
	
	if not player.platform_area:
		state_machine.transition_to("Idle")

		

