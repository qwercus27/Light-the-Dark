extends PlayerState


func enter(msg := {}) -> void:
	
	print("entered die state")
	player.velocity.y = player.jump_v
	player.get_node("RunningAudio").stop()


func physics_update(delta: float) -> void:
	player.get_node("Interact").set_monitorable(false)
	player.get_node("CollisionShape2D").disabled = true
	player.get_node("Hurtbox/CollisionShape2D").disabled = true
	player.velocity.y += player.gravity * delta
	player.position.y += player.velocity.y * delta

