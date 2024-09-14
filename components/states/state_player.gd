class_name PlayerState
extends State

var player: Player


func _ready() -> void:
	await owner.ready
	player = owner as Player
	assert(player != null)
	player.get_node("HealthComponent").damaged.connect(on_damaged)
	player.grabbed_ladder.connect(on_grabbed_ladder)
	player.grabbed_box.connect(on_grabbed_box)
	#player.bounce_activated.connect(on_bounce_activated)


func on_grabbed_ladder():
	if state_machine.state.name != "Climbing":
		state_machine.transition_to("Climbing")

func on_damaged():
	if state_machine.state.name != "Damaged":
		state_machine.transition_to("Damaged")

func on_bounce_activated():
	state_machine.transition_to("Air")

func on_grabbed_box():
	
	state_machine.transition_to("Push")



