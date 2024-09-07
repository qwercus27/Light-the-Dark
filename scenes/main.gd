extends Node2D

var game_scale = 3
var current_level
var torches_lit = 0
var door
var test_modes = {"fly" : false, "pan" : false, "no collision" : false, "illuminate" : false}

# Called when the node enters the scene tree for the first time.
func _ready():
	
	torches_lit = 0
	
	current_level = Global.current_level.instantiate()
	add_child(current_level)
	
	$Player.z_index = 1
	$Player.position = current_level.get_node("StartPos").position * Vector2(game_scale,game_scale)
	$Player.get_node("StateMachine").transition_to("Air")
	$Player._ready()
	
	if not AudioStreamer.get_node("Music").playing:
		AudioStreamer.get_node("Music").play()
	
	current_level.torch_count = current_level.get_node("TileMap").get_used_cells(2).size()
	print("torch count: " + str(current_level.torch_count))
	door = current_level.get_node("Door")
	current_level.get_node("DirectionalLight2D").visible = false
	
	display_level_title()
	set_camera_limit()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	test_mode_settings()
	
	camera_control(delta)
	
	if torches_lit == current_level.torch_count and door.locked :
		door.unlock()
		current_level.get_node("DirectionalLight2D").visible = true
		current_level.turn_on_lights()

	$Player.position.x = clamp($Player.position.x, 16, 
		current_level.get_node("TileMap").get_used_rect().size.x*16*game_scale - 16)
		
	$KeyHUD/Label.text = "x " + str($Player.key_count)

	if Input.is_action_just_pressed("k"):
		$Player.key_count += 1
	
	
func test_mode_settings():
	
	if Input.is_action_pressed("control"):
		
		test_modes["pan"] = true
		$Player.process_mode = Node.PROCESS_MODE_DISABLED
		
		if Input.is_action_just_pressed("i"):
			test_modes["illuminate"] = not test_modes["illuminate"]
			current_level.get_node("DirectionalLight2D").visible = not current_level.get_node("DirectionalLight2D").visible
		
		if Input.is_action_just_pressed("f"):
			test_modes["fly"] = not test_modes["fly"]
			
			if test_modes["fly"]:
				$Player.get_node("StateMachine").transition_to("Fly")
			else:
				$Player.get_node("StateMachine").transition_to("Idle")

		if test_modes["fly"]:
			if Input.is_action_just_pressed("c"):
				$Player.toggle_collision()
				test_modes["no collision"] = not test_modes["no collision"]
				
	else:
		test_modes["pan"] = false
		$Player.process_mode = Node.PROCESS_MODE_PAUSABLE
		
	if not test_modes["fly"]:
		$Player.get_node("CollisionShape2D").disabled = false
		test_modes["no collision"] = false
		
func camera_control(delta):
	
	var cam_speed = 400
	if not test_modes["pan"]:
		$Camera.position.x = $Player.position.x
		$Camera.position.y = $Player.position.y
	else:
		if Input.is_action_pressed("up"):
			print("moving up")
			$Camera.position.y -= delta * cam_speed
		elif Input.is_action_pressed("down"):
			$Camera.position.y += delta * cam_speed
		if Input.is_action_pressed("left"):
			$Camera.position.x -= delta * cam_speed
		elif Input.is_action_pressed("right"):
			$Camera.position.x += delta * cam_speed


func set_camera_limit():
	
	var tilemap_rect = current_level.get_node("TileMap").get_used_rect()

	$Camera.set_limit(SIDE_LEFT, 0)
	$Camera.set_limit(SIDE_TOP, 0)
	$Camera.set_limit(SIDE_RIGHT, tilemap_rect.size.x*16*3)
	$Camera.set_limit(SIDE_BOTTOM, tilemap_rect.size.y*16*3)

func _on_player_lit_torch():
	torches_lit += 1


func _on_player_opened_door():
	
	door.open()
	$NextLevelTimer.start()
	$Player.exit(door.position.x)
	#$HUD/ClearedLabel.visible = true


func player_boundaries():
	
	$Player.position.x = clamp($Player.position.x, 0, 
		current_level.get_node("TileMap").get_used_rect().size.x*16*game_scale)
	
func change_level(level_id):
	
	current_level.queue_free()
	Global.current_level = load("res://scenes/levels/level_" + str(level_id) + ".tscn")
	_ready()


func _on_next_level_timer_timeout():
	
	if current_level.level_name == "Level 5":
		Global.current_level = load("res://scenes/levels/level_1.tscn")
		get_tree().change_scene_to_file("res://scenes/start_menu.tscn")
	else:
		var next_level = int(current_level.level_name.split(" ")[1]) + 1
		change_level(next_level)


func _on_player_hit():
	
	$DeathTimer.start()


func _on_death_timer_timeout():
	
	current_level.queue_free()
	_ready()


func display_level_title():
	
	$LevelTitle/Label.text = current_level.level_name
	$LevelTitle.visible = true
	$TitleTimer.start(3)


func _on_title_timer_timeout():
	
	$LevelTitle.visible = false
