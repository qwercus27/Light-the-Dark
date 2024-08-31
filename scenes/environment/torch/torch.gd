extends Node2D

var energy_goal_texture
var energy_goal_shadow
var change = false
var change_rate = 0.1
var ratio

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.set_animation("unlit")
	$InteractHint.visible = false
	ratio = $Lights/ShadowLight.energy / $Lights/TextureLight.energy


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if(change):
		balance_energy()
	
func interact():
	if not $Lights.visible:
		$FlameAudio.play()
	$Lights.visible = true
	$AnimatedSprite2D.set_animation("lit")
	$InteractHint.visible = false

func show_hint():
	$InteractHint.visible = true

func hide_hint():
	$InteractHint.visible = false
	
func turn_on():
	$Lights.visible = true
	$AnimatedSprite2D.set_animation("lit")
	$InteractHint.visible = false
	
func _on_interact_area_entered(area):
	if area.is_in_group("player"):
		if $AnimatedSprite2D.animation == "unlit":
			show_hint()

func _on_interact_area_exited(area):
	if area.is_in_group("player"):
		hide_hint()
		
func balance_energy():
	
	var difference_shadow = $Lights/ShadowLight.energy - energy_goal_shadow
	var difference_texture = $Lights/TextureLight.energy - energy_goal_texture
	
	if difference_shadow > 0:
		$Lights/ShadowLight.energy -= change_rate * ratio
	elif difference_shadow < 0:
		$Lights/ShadowLight.energy += change_rate * ratio

	if difference_texture > 0:
		$Lights/TextureLight.energy -= change_rate
	elif difference_texture < 0:
		$Lights/TextureLight.energy += change_rate
	else:
		change = false
		
func change_energy(percent_change, rate):
	
	energy_goal_shadow = $Lights/ShadowLight.energy * percent_change
	energy_goal_texture = $Lights/TextureLight.energy * percent_change
	change_rate = rate
	change = true
	
