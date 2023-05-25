extends CharacterBody2D
# ------ State Descripitons ------

#Spawn_Player: Switches STATE_LEVEL and STATE_PLAYER to "Player_Spawning"; triggers Spawn animation
#
#Player_Spawning: doesn't trigger anything allowing Player's Spawn animation to finish
#
#Move_Normal: Triggered when Spawn animation completes; 
#
#Player_DeSpawning: doesn't trigger anything allowing Player's "Exit" animation to complete 
#
#Dying:
#
#InWater:
#
#Bounce: 

func _ready():
	set_player()

func _physics_process(delta):
	set_camera()
	check_state()
	exec_state(delta)


func check_state():
	if GlobalDictionaries.current_data["Hearts_Current"] <= 0 and Global.STATE_PLAYER != "Dead":
		Global.STATE_PLAYER = "Dying"
	elif Global.STATE_PLAYER == "InWater":
		Global.STATE_PLAYER = "Dying"
	elif Global.STATE_LEVEL == "Portal_Enter_Open":
		Global.STATE_PLAYER = "Portal_Enter_Open"
	elif Global.STATE_LEVEL == "Player_Spawn":
		Global.STATE_PLAYER = "Player_Spawn"


func exec_state(delta):
	if Global.STATE_PLAYER == "Player_Spawn":
		exec_state_spawn_player()
	elif Global.STATE_PLAYER == "Dying":
		exec_state_dying()
	elif Global.STATE_PLAYER == "Bounce":
		exec_state_bounce()
	elif Global.STATE_PLAYER == "Move_Normal" and GlobalDictionaries.current_data["Flags"]["On_Vines"] == false:
		exec_state_move(delta)
	elif Global.STATE_PLAYER == "Move_Normal" and GlobalDictionaries.current_data["Flags"]["On_Vines"] == true:
		exec_state_move_vines(delta)

func exec_state_spawn_player():
	Global.STATE_LEVEL = "Player_Spawning"
	Global.STATE_PLAYER = "Player_Spawning"
	Global.Player["Animation"] = "Spawn"
	self.set_animation()

func exec_state_move(delta):
	
	var dir_x = Input.get_axis("move_left", "move_right")
	
	if not is_on_floor():
		velocity.y += GlobalDictionaries.current_data["Game_Info"]["Gravity"] * delta 
		get_animation_y()
	else:
		get_animation_x()
	
	if Input.is_action_just_pressed("action_interact") and GlobalDictionaries.current_data["Flags"]["Can_OpenChest"] == true:
		exec_state_open_chest()
	elif GlobalDictionaries.current_data["Flags"]["On_Enemy"] == true:
		GlobalDictionaries.current_data["Flags"]["On_Enemy"] = false
		exec_state_damage()
	elif GlobalDictionaries.current_data["Flags"]["On_Spikes"] == true:
		GlobalDictionaries.current_data["Flags"]["On_Spikes"] = false
		exec_state_damage()
	elif dir_x:
		exec_state_move_horizontal(dir_x)
	else:
		exec_state_move_idle()
	
	if Input.is_action_pressed("action_item_use") and GlobalDictionaries.current_data["Current_Item"] == "Jetpack":
		exec_state_move_jump(GlobalDictionaries.current_data["Game_Info"]["Jump_Height"] * .7)
	elif is_on_floor():
		if Input.is_action_just_pressed("move_jump"):
			exec_state_move_jump(GlobalDictionaries.current_data["Game_Info"]["Jump_Height"])
	elif Input.is_action_pressed("move_down"):
		velocity.y += GlobalDictionaries.current_data["Game_Info"]["Gravity"] * delta 
	
	set_animation()	
	move_and_slide()

func exec_state_move_horizontal(direction):
	velocity.x = direction * GlobalDictionaries.current_data["Game_Info"]["SpeedMax"]
	
	if velocity.x < 0:
		$Sprite2D.flip_h = true
	else:
		$Sprite2D.flip_h = false

func exec_state_move_idle():
	velocity.x = move_toward(velocity.x, 0, GlobalDictionaries.current_data["Game_Info"]["SpeedMax"])

func exec_state_move_jump(Jump_Height):
	velocity.y = Jump_Height

func exec_state_move_vines(delta):
	
	var dir_y = Input.get_axis("move_up", "move_down")
	var dir_x = Input.get_axis("move_left", "move_right")
	
	if not is_on_floor():
		if dir_x or dir_y:
			Global.Player["Animation"] = "Vines"
		else:
			Global.Player["Animation"] = "VinesIdle"
	else:
		get_animation_x()
	
	if dir_x:
		exec_state_move_horizontal_vines(dir_x)
	elif dir_y:
		exec_state_move_vertical_vines(dir_y)
	else:
		exec_state_idle_vines()
	
	set_animation()
	move_and_slide()

func exec_state_move_horizontal_vines(direction):
	if is_on_floor():
		velocity.x = direction * GlobalDictionaries.current_data["Game_Info"]["SpeedMax"]
	else:
		velocity.x = direction * GlobalDictionaries.current_data["Game_Info"]["SpeedMax"] / 2

func exec_state_move_vertical_vines(direction):
	if direction < 0:
		velocity.y = direction * GlobalDictionaries.current_data["Game_Info"]["SpeedMax"] * .7
	else:
		velocity.y = direction * (GlobalDictionaries.current_data["Game_Info"]["SpeedMax"] * 1.5)

func exec_state_idle_vines():
	velocity.x = 0
	velocity.y = 0

func exec_state_open_chest():

	GlobalDictionaries.current_data["Flags"]["Can_OpenChest"] = false
	Global.STATE_PLAYER = "Chest_Opening"
	Global.Player["Animation"] = "Interact"

func exec_state_bounce():
	velocity.y = GlobalDictionaries.current_data["Interactions"]["Jumpshroom"]["BounceHeight"]
	Global.STATE_PLAYER = "Move_Normal"

func exec_state_damage():
	if GlobalDictionaries.current_data["Hearts_Current"] > 0:
		GlobalDictionaries.current_data["Hearts_Current"] -= 1
		$AnimationPlayer2.play("Damage")
	else:
		Global.STATE_PLAYER = "Dying"

func exec_state_dying():
	velocity.x = 0
	Global.Player["Animation"] = "Die"
	set_animation()



func get_animation_y():

	if velocity.y < 0:
		if Input.is_action_pressed("action_item_use") and GlobalDictionaries.current_data["Current_Item"] == "Jetpack":
			Global.Player["Animation"] = "Jetpack"
		else:
			Global.Player["Animation"] = "Jump"
	else:
		Global.Player["Animation"] = "Fall"

func get_animation_x():
	
	if velocity.x == 0:
		Global.Player["Animation"] = "Idle"
	else:
		if GlobalDictionaries.current_data["Flags"]["Can_Push"] == true:
			if GlobalDictionaries.current_data["Flags"]["Crate_R"]:
				if $Sprite2D.flip_h:
					Global.Player["Animation"] = "Push"
				else:
					Global.Player["Animation"] = "Pull"
			else:
				if $Sprite2D.flip_h:
					Global.Player["Animation"] = "Pull"
				else:
					Global.Player["Animation"] = "Push"
		else:
			Global.Player["Animation"] = "Run"


func set_player():
	if Global.is_debug:
		GlobalDictionaries.players["1"] = GlobalDictionaries.get_new_player_dict("Debug")
		Global.Player = GlobalDictionaries.players["1"]
		Global.Player["Name_Explorer"] = "Nico"
		GlobalDictionaries.game["PlayerKey"] = "1"
		GlobalDictionaries.game["Level_Current"] = int(get_parent().name.replace("Level_",""))
		Global.Player["Level_Max"] = int(get_parent().name.replace("Level_",""))
#		Global.STATE_PLAYER = "Move_Normal"
	else:
		Global.Player = GlobalDictionaries.players[str(GlobalDictionaries.game["PlayerKey"])]

func set_animation():
	if Global.Player["Animation"] == "VinesIdle":
		$AnimationPlayer.speed_scale = 0
	else:
		$AnimationPlayer.speed_scale = 1
		var anim_name = Global.Player["Name_Explorer"] + "_" + Global.Player["Animation"]
		var curr_anim = $AnimationPlayer.current_animation

		if curr_anim != anim_name:
			$AnimationPlayer.play(anim_name)

func set_camera():
	
	if Global.STATE_PLAYER == "Move_Normal":
		if Input.is_action_pressed("camera_right"):
			$Camera2D.position += Vector2(15, 0)
		if Input.is_action_pressed("camera_left"):
			$Camera2D.position += Vector2(-15, 0)
		if Input.is_action_pressed("camera_up"):
			$Camera2D.position += Vector2(0, -15)
		if Input.is_action_pressed("camera_down"):
			$Camera2D.position += Vector2(0, 15)
		if Input.is_action_pressed("camera_center"):
			$Camera2D.position = Vector2(0, 0)


func _on_animation_player_animation_finished(anim_name):
	
	if anim_name.find("_Interact") != -1:
		Global.STATE_PLAYER = "Move_Normal"
	elif anim_name.find("_Die") != -1:
		Global.STATE_PLAYER = "Dead"
	elif anim_name.find("_Spawn") != -1:
		Global.STATE_PLAYER = "Move_Normal"
		Global.STATE_LEVEL = "Portal_Enter_Close"

func _on_animation_player_2_animation_finished(anim_name):
	pass # Replace with function body.
