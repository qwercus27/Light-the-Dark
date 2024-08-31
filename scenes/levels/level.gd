class_name Level
extends Node2D

@export var level_name : String
var torch_count

# Called when the node enters the scene tree for the first time.
func _ready():
	$DirectionalLight2D.energy = 0
	if($LitTorch):
		$LitTorch.turn_on()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$DirectionalLight2D.energy = .5 - ($LightsOnTimer.time_left * .5)


func _on_visible_on_screen_notifier_2d_screen_entered():
	$PlantNote.set_visible(true)


func turn_on_lights():
	$LightsOnTimer.start()
	var child_array = $TileMap.get_children()
	for item in child_array:
		if item.is_in_group("torch"):
			item.change_energy(0.35, .02)
	
