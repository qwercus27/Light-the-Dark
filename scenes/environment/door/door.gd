extends Node2D

var locked = true

# Called when the node enters the scene tree for the first time.
func _ready():
	lock()
	$InteractHint.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func unlock():
	$AnimatedSprite2D.animation = "unlocked"
	$Interact/CollisionShape2D.disabled = false
	locked = false


func open():
	$AnimatedSprite2D.animation = "opened"
	$InteractHint.visible = false
	$DoorOpenAudio.play()
	
	
func close():
	$AnimatedSprite2D.animation = "unlocked"


func lock():
	$AnimatedSprite2D.animation = "locked"
	$Interact/CollisionShape2D.disabled = true
	locked = true


func show_hint():
	$InteractHint.visible = true
	
	
func hide_hint():
	$InteractHint.visible = false
	
	
func _on_interact_area_entered(area):
	if area.is_in_group("player"):
		if $AnimatedSprite2D.animation == "unlocked":
			show_hint()


func _on_interact_area_exited(area):
	if area.is_in_group("player"):
		hide_hint()
