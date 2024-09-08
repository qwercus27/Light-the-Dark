extends Node2D

#@export var switch_id : int
var area_count = 0
signal switch_pressed
signal switch_released

var pressed = false

# Called when the node enters the scene tree for the first time.
func _ready():
	switch_pressed.connect(_on_switch_pressed)
	switch_released.connect(_on_switch_released)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if area_count > 0:
		descend(delta)
	else:
		ascend(delta)


func descend(delta):
	if pressed == false:
		"pressing"
		$Switch/TopBody.position.y = move_toward($Switch/TopBody.position.y, 
			$Switch/BaseSprite.position.y + 1.5, delta * 4)
		if $Switch/TopBody.position.y == $Switch/BaseSprite.position.y + 1.5:
			"opening gate"
			open_gate()
			pressed = true
		

func ascend(delta):
	if pressed == true:
		$Switch/TopBody.position.y = move_toward($Switch/TopBody.position.y, 
			$Switch/BaseSprite.position.y - 0.5, delta * 4)
		if $Switch/TopBody.position.y == $Switch/BaseSprite.position.y - 0.5:
			close_gate()
			pressed = false

func open_gate():
	$Gate/StaticBody2D/CollisionShape2D.disabled = true
	$Gate/Sprite2D.visible = false
	
func close_gate():
	$Gate/StaticBody2D/CollisionShape2D.disabled = false
	$Gate/Sprite2D.visible = true
	
func _on_interact_area_entered(area):
	area_count += 1
	print("switch area entered")

func _on_interact_area_exited(area):
	area_count -= 1
	print("switch area exited")

func _on_switch_pressed():
	open_gate()

func _on_switch_released():
	close_gate()
