extends PlayerState

var destination

func enter(msg := {}) -> void:

	var timer := Timer.new()
	add_child(timer)
	timer.timeout.connect(on_timer_timeout)
	timer.one_shot = true
	timer.autostart = false
	timer.start(1)
	print("entered damaged state")
	
# Called when the node enters the scene tree for the first time.
func physics_update(delta: float) -> void:
	
	player.velocity.y += player.gravity * delta
	player.velocity.x = move_toward(player.velocity.x, 0, 10)
	player.move_and_slide()
	
		
func on_timer_timeout():
	if not player.is_on_floor():
		state_machine.transition_to("Air")
		return
	else:
		state_machine.transition_to("Idle")
