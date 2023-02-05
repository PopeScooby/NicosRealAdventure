extends KinematicBody2D

const UP = Vector2(0,-1)

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

var motion = Vector2(0,0)

func _ready():
#	self.visible = false
	$SpeechBubble.visible = false
	set_player()

func _process(delta):

#	var anim_curr = $AnimationPlayer.current_animation
#	var anim_speed = $AnimationPlayer.playback_speed

	check_state()
	exec_state()

func check_state():
	pass
	if GlobalDictionaries.current_data["Hearts_Current"] <= 0 and Global.STATE_PLAYER != "Dead":
		Global.STATE_PLAYER = "Dying"
	elif Global.STATE_PLAYER == "InWater":
		Global.STATE_PLAYER = "Dying"
	elif Global.STATE_LEVEL == "Spawn_Player":
		Global.STATE_PLAYER = "Spawn_Player"


func exec_state():
	pass
	if Global.STATE_PLAYER == "Spawn_Player":
		exec_state_spawn_player()
#	elif Global.STATE_PLAYER == "Start_Scene":
#		exec_state_start_scene()
#	elif Global.STATE_PLAYER == "Complete_Scene":
#		exec_state_complete_scene()
	elif Global.STATE_PLAYER == "Dying":
		exec_state_dying()
	elif Global.STATE_PLAYER == "Bounce":
		exec_state_bounce()
#	elif Global.STATE_PLAYER == "ExitHospital":
#		exec_state_exit_hospital()
#	elif Global.STATE_PLAYER == "ExitMushRoom":
#		exec_state_exit_mush_room()
#	elif Global.STATE_PLAYER == "Move_Normal" and GlobalDictionaries.current_data["Flags"]["On_Enemy"] == true:
#		GlobalDictionaries.current_data["Flags"]["On_Enemy"] = false
#		exec_state_damage()
	elif Global.STATE_PLAYER == "Move_Normal" and GlobalDictionaries.current_data["Flags"]["On_Spikes"] == true:
		GlobalDictionaries.current_data["Flags"]["On_Spikes"] = false
		exec_state_damage()
	elif Global.STATE_PLAYER == "Move_Normal" and GlobalDictionaries.current_data["Flags"]["On_Vines"] == false:
		exec_state_move()
	elif Global.STATE_PLAYER == "Move_Normal" and GlobalDictionaries.current_data["Flags"]["On_Vines"] == true:
		exec_state_move_vines()

func exec_state_move():

	if GlobalDictionaries.current_data["Game_Info"]["Dir_Curr"] != 0:
		GlobalDictionaries.current_data["Game_Info"]["Dir_Prev"] = GlobalDictionaries.current_data["Game_Info"]["Dir_Curr"]

	GlobalDictionaries.current_data["Game_Info"]["Friction"] = false

	if GlobalDictionaries.current_data["Flags"]["On_Crate"] == true and is_on_floor():
		motion.y = 1
	else:
		motion.y += GlobalDictionaries.current_data["Game_Info"]["Gravity"]


	if Input.is_action_just_pressed("action_interact") and GlobalDictionaries.current_data["Flags"]["Can_OpenChest"] == true:
		exec_state_open_chest()
	elif Input.is_action_just_pressed("action_interact") and GlobalDictionaries.current_data["Flags"]["On_Exit"] == true:
		exec_state_despawn_player()
#	elif Input.is_action_just_pressed("action_interact") and GlobalDictionaries.current_data["Flags"]["On_Hospital"] == true:
#		exec_state_go_to_hospital()
#	elif Input.is_action_just_pressed("action_interact") and GlobalDictionaries.current_data["Flags"]["On_MushRoom"] == true:
#		exec_state_go_to_mush_room()
#	elif Input.is_action_just_pressed("action_use_item") and GlobalDictionaries.current_data["Current_Item"] != "":
#		exec_state_use_item()
#	elif Input.is_action_just_pressed("action_switch_item") and GlobalDictionaries.current_data["Current_Item"] != "":
#		exec_state_switch_item()
	elif GlobalDictionaries.current_data["Flags"]["Can_Push"] == true:
		exec_state_push()
	elif Input.is_action_pressed("move_right"):
		exec_state_move_right()
	elif Input.is_action_pressed("move_left"):
		exec_state_move_left()
#	elif Input.is_action_pressed("move_down") and is_on_floor():
#		exec_state_move_crouch()
	else:
		exec_state_idle()

	if is_on_floor():
		if Input.is_action_just_pressed("move_jump"):
			GlobalDictionaries.current_data["Flags"]["On_Crate"] = false
			exec_state_move_jump()

		if GlobalDictionaries.current_data["Game_Info"]["Friction"] == true:
			motion.x = lerp(motion.x, 0, 0.8)
	else:
		if GlobalDictionaries.current_data["Game_Info"]["Friction"] == true:
			motion.x = lerp(motion.x, 0, 0.4)

	set_animation()

	motion = move_and_slide(motion, UP)

func exec_state_idle():
	GlobalDictionaries.current_data["Game_Info"]["Dir_Curr"] = GlobalDictionaries.current_data["Game_Info"]["Dir_Prev"]
	GlobalDictionaries.current_data["Game_Info"]["Friction"] = true
	if is_on_floor():
		Global.Player["Animation"] = "Idle"
	else:
		if motion.y < 0 and GlobalDictionaries.current_data["Flags"]["Can_Climb"] == false:
			Global.Player["Animation"] = "Jump"
		else:
			if  GlobalDictionaries.current_data["Flags"]["On_Elevator"] == false:
				Global.Player["Animation"] = "Fall"
			else:
				Global.Player["Animation"] = "Idle"

func exec_state_move_right():
	GlobalDictionaries.current_data["Game_Info"]["Dir_Curr"] = 1
	motion.x = min(motion.x + GlobalDictionaries.current_data["Game_Info"]["Acceleration"], GlobalDictionaries.current_data["Game_Info"]["SpeedMax"])
	if is_on_floor():
		Global.Player["Animation"] = "Run"
	else:
		if motion.y < 0:
			Global.Player["Animation"] = "Jump"
		else:
			Global.Player["Animation"] = "Fall"

func exec_state_move_left():
	GlobalDictionaries.current_data["Game_Info"]["Dir_Curr"] = -1
	motion.x = max(motion.x - GlobalDictionaries.current_data["Game_Info"]["Acceleration"], -GlobalDictionaries.current_data["Game_Info"]["SpeedMax"])
	if is_on_floor():
		Global.Player["Animation"] = "Run"
	else:
		if motion.y < 0:
			Global.Player["Animation"] = "Jump"
		else:
			Global.Player["Animation"] = "Fall"

#func exec_state_move_crouch():
#
#	if GlobalDictionaries.current_data["Game_Info"]["Dir_Curr"] == 0:
#		GlobalDictionaries.current_data["Game_Info"]["Dir_Curr"] = GlobalDictionaries.current_data["Game_Info"]["Dir_Prev"]
#
#	GlobalDictionaries.current_data["Game_Info"]["Friction"] = true
#	Global.Player["Animation"] = "Crouch"
#
func exec_state_move_jump():
	if is_on_floor():
		motion.y = GlobalDictionaries.current_data["Game_Info"]["JumpHeight"]

func exec_state_spawn_player():
	Global.STATE_LEVEL = "Player_Spawning"
	Global.STATE_PLAYER = "Player_Spawning"
	Global.Player["Animation"] = "Spawn"
	self.set_animation()

func exec_state_despawn_player():
	Global.STATE_LEVEL = "Player_DeSpawning"
	Global.STATE_PLAYER = "Player_DeSpawning"
	Global.Player["Animation"] = "Exit"

func exec_state_open_chest():

	GlobalDictionaries.current_data["Flags"]["Can_OpenChest"] = false

	Global.STATE_PLAYER = "Chest_Opening"
	if GlobalDictionaries.current_data["Game_Info"]["Dir_Curr"] == 0:
		GlobalDictionaries.current_data["Game_Info"]["Dir_Curr"] = GlobalDictionaries.current_data["Game_Info"]["Dir_Prev"]

	if GlobalDictionaries.current_data["Game_Info"]["Dir_Curr"] == 1:
		Global.Player["Animation"] = "Interact"
	elif  GlobalDictionaries.current_data["Game_Info"]["Dir_Curr"] == -1:
		Global.Player["Animation"] = "Interact"

func exec_state_push():

	if Input.is_action_pressed("move_right"):
		exec_state_push_right()
	elif Input.is_action_pressed("move_left"):
		exec_state_push_left()
	else:
		exec_state_push_idle()

func exec_state_push_right():
	GlobalDictionaries.current_data["Game_Info"]["Dir_Curr"] = 1
	motion.x = min(motion.x + GlobalDictionaries.current_data["Game_Info"]["Acceleration"], GlobalDictionaries.current_data["Game_Info"]["SpeedMax"])
	if GlobalDictionaries.current_data["Flags"]["Crate_R"]:
		Global.Player["Animation"] = "Pull"
	else:
		Global.Player["Animation"] = "Push"

func exec_state_push_left():
	GlobalDictionaries.current_data["Game_Info"]["Dir_Curr"] = -1
	motion.x = max(motion.x - GlobalDictionaries.current_data["Game_Info"]["Acceleration"], -GlobalDictionaries.current_data["Game_Info"]["SpeedMax"])
	if GlobalDictionaries.current_data["Flags"]["Crate_R"]:
		Global.Player["Animation"] = "Push"
	else:
		Global.Player["Animation"] = "Pull"

func exec_state_push_idle():
	GlobalDictionaries.current_data["Game_Info"]["Dir_Curr"] = GlobalDictionaries.current_data["Game_Info"]["Dir_Prev"]
	GlobalDictionaries.current_data["Game_Info"]["Friction"] = true
	Global.Player["Animation"] = "Idle"

func exec_state_bounce():
	motion.y = GlobalDictionaries.current_data["Interactions"]["Jumpshroom"]["BounceHeight"]
	Global.STATE_PLAYER = "Move_Normal"

func exec_state_dying():
	motion.x = 0
	Global.Player["Animation"] = "Die"
	set_animation()

func exec_state_move_vines():

	if GlobalDictionaries.current_data["Game_Info"]["Dir_Curr"] != 0:
		GlobalDictionaries.current_data["Game_Info"]["Dir_Prev"] = GlobalDictionaries.current_data["Game_Info"]["Dir_Curr"]

	GlobalDictionaries.current_data["Game_Info"]["Friction"] = false

	if Input.is_action_pressed("move_right"):
		exec_state_move_right_vines()
	elif Input.is_action_pressed("move_left"):
		exec_state_move_left_vines()
	elif Input.is_action_pressed("move_up"):
		exec_state_move_up_vines()
	elif Input.is_action_pressed("move_down"):
		exec_state_move_down_vines()
	else:
		exec_state_idle_vines()
#
#	if Input.is_action_just_pressed("move_jump"):
#		exec_state_move_jump_vines()

	set_animation()

	motion = move_and_slide(motion, UP)

func exec_state_move_right_vines():
	GlobalDictionaries.current_data["Game_Info"]["Dir_Curr"] = 1
	motion.x = min(motion.x + GlobalDictionaries.current_data["Game_Info"]["Acceleration"], GlobalDictionaries.current_data["Game_Info"]["SpeedMax"])
	if is_on_floor():
		Global.Player["Animation"] = "Run"
	else:
		if motion.y < 0:
			Global.Player["Animation"] = "Vines"
		else:
			Global.Player["Animation"] = "Vines"

func exec_state_move_left_vines():
	GlobalDictionaries.current_data["Game_Info"]["Dir_Curr"] = -1
	motion.x = max(motion.x - GlobalDictionaries.current_data["Game_Info"]["Acceleration"], -GlobalDictionaries.current_data["Game_Info"]["SpeedMax"])
	if is_on_floor():
		Global.Player["Animation"] = "Run"
	else:
		if motion.y < 0:
			Global.Player["Animation"] = "Vines"
		else:
			Global.Player["Animation"] = "Vines"

func exec_state_move_up_vines():
	GlobalDictionaries.current_data["Game_Info"]["Dir_Curr"] = GlobalDictionaries.current_data["Game_Info"]["Dir_Prev"]
	motion.y = max(motion.x - GlobalDictionaries.current_data["Game_Info"]["Acceleration"] * 1.5, -GlobalDictionaries.current_data["Game_Info"]["SpeedMax"])
	if is_on_floor():
		Global.Player["Animation"] = "Run"
	else:
		if motion.y < 0:
			Global.Player["Animation"] = "Vines"
		else:
			Global.Player["Animation"] = "Vines"

func exec_state_move_down_vines():
	GlobalDictionaries.current_data["Game_Info"]["Dir_Curr"] = GlobalDictionaries.current_data["Game_Info"]["Dir_Prev"]
	motion.y = min(motion.x + GlobalDictionaries.current_data["Game_Info"]["Acceleration"] * 3, GlobalDictionaries.current_data["Game_Info"]["SpeedMax"])
	if is_on_floor():
		Global.Player["Animation"] = "Idle"
	else:
		if motion.y < 0:
			Global.Player["Animation"] = "Vines"
		else:
			Global.Player["Animation"] = "Vines"

#func exec_state_move_jump_vines():
#	motion.y = GlobalDictionaries.current_data["Game_Info"]["JumpHeight"] * 15
#
func exec_state_idle_vines():
	GlobalDictionaries.current_data["Game_Info"]["Dir_Curr"] = GlobalDictionaries.current_data["Game_Info"]["Dir_Prev"]
	motion.y = 0
	motion.x = 0
	if is_on_floor():
		Global.Player["Animation"] = "Idle"
	else:
		if motion.y < 0:
			Global.Player["Animation"] = "VinesIdle"
		else:
			Global.Player["Animation"] = "VinesIdle"

func exec_state_damage():

	if GlobalDictionaries.current_data["Hearts_Current"] > 0:
		GlobalDictionaries.current_data["Hearts_Current"] -= 1
		$AnimationPlayer2.play("Damage")
	else:
		Global.STATE_PLAYER = "Dying"

#func exec_state_start_scene():
#	$AnimationPlayer.playback_speed = 0
#	if Global.Player["Scenes"][Global.Player["Scenes"]["Scene_Curr"]["SceneName"]]["Parent"] == "Adventurer":
#		var anim_name = "Scene_" + Global.Player["Scenes"]["Scene_Curr"]["SceneName"]
#		$AnimationPlayer2.play(anim_name)
#	else:
#		$SpeechBubble.visible = false
##
##func exec_state_continue_scene():
##	$AnimationPlayer2.stop()
#
#func exec_state_complete_scene():
#	$SpeechBubble.visible = false
#	$AnimationPlayer.playback_speed = 1
#	if Global.Player["Scenes"][Global.Player["Scenes"]["Scene_Curr"]["SceneName"]]["Parent"] == "Adventurer":
#		Global.Player["Scenes"][Global.Player["Scenes"]["Scene_Curr"]["SceneName"]]["Seen"] = true
#		Global.STATE_PLAYER = "Move_Normal"
#
#func exec_state_go_to_hospital():
#	Global.STATE_PLAYER = "GoToHospital"
#	Global.Player["Animation"] = "GoToHospital"
##	Global.STATE_LEVEL = "GoToHospital"
#
#func exec_state_exit_hospital():
#	Global.STATE_PLAYER = "ExitingHospital"
#	Global.Player["Animation"] = "LeaveHospital"
#
#	set_animation()
#
#func exec_state_go_to_mush_room():
#	Global.STATE_PLAYER = "GoToMushRoom"
#	Global.Player["Animation"] = "GoToMushRoom"
#
#func exec_state_exit_mush_room():
#	Global.STATE_PLAYER = "ExitingMushRoom"
#	Global.Player["Animation"] = "LeaveMushRoom"
#
#	set_animation()
#
#func exec_state_use_item():
#	if GlobalDictionaries.current_data["Current_Item"] == "Jumpshroom" and is_on_floor() and GlobalDictionaries.current_data["Flags"]["On_Crate"] == false:
#		for item in GlobalDictionaries.current_data["Item_Data"]:
#			if item.find("Jumpshroom") != -1 and GlobalDictionaries.current_data["Item_Data"][item]["InInventory"] == true:
#				if GlobalDictionaries.current_data["Game_Info"]["Dir_Curr"] == 0:
#					GlobalDictionaries.current_data["Game_Info"]["Dir_Curr"] = GlobalDictionaries.current_data["Game_Info"]["Dir_Prev"]
#
#				GlobalDictionaries.current_data["Game_Info"]["Friction"] = true
#				Global.STATE_PLAYER = "PlacingItem"
#				Global.Player["Animation"] = "PlaceJumpshroom"
#				GlobalDictionaries.current_data["Item_Placing"] = item
#
#	elif GlobalDictionaries.current_data["Current_Item"] == "Handle" and GlobalDictionaries.current_data["Flags"]["Near_LeverBase"] == false:
#		for item in Global.items:
#			if item.find("Handle") != -1 and Global.items[item]["InInventory"] == true:
#				if GlobalDictionaries.current_data["Game_Info"]["Dir_Curr"] == 0:
#					GlobalDictionaries.current_data["Game_Info"]["Dir_Curr"] = GlobalDictionaries.current_data["Game_Info"]["Dir_Prev"]
#
#				GlobalDictionaries.current_data["Game_Info"]["Friction"] = true
#				Global.STATE_PLAYER = "PlacingItem"
#				Global.Player["Animation"] = "PlaceHandle"
#				Global.item_placing = item
#
#func exec_state_switch_item():
#	var items = GlobalDictionaries.current_data["Inventory"].keys()
#	var curr_item_idx = items.find(GlobalDictionaries.current_data["Current_Item"], 0)
#	var max_item_idx = items.size() - 1
#
#	if max_item_idx == 0:
#		pass
#	else:
#		if curr_item_idx == max_item_idx:
#			curr_item_idx = 0
#		else:
#			curr_item_idx += 1
#
#	GlobalDictionaries.current_data["Current_Item"] = items[curr_item_idx]

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
		
#	if GlobalDictionaries.players.size() != 0:
#		Global.Player = GlobalDictionaries.players[str(GlobalDictionaries.game["PlayerKey"])]
#	else:
#		GlobalDictionaries.players["1"] = GlobalDictionaries.get_new_player_dict("Debug")
#		Global.Player = GlobalDictionaries.players["1"]
#		Global.Player["Name_Explorer"] = "Nico"
#		GlobalDictionaries.game["PlayerKey"] = "1"
#		GlobalDictionaries.game["Level_Current"] = int(get_parent().name.replace("Level_",""))
#		Global.Player["Level_Max"] = int(get_parent().name.replace("Level_",""))


func set_animation():

	if Global.Player["Animation"] == "VinesIdle":
		$AnimationPlayer.playback_speed = 0
	else:
		$AnimationPlayer.playback_speed = 1
		var anim_name = Global.Player["Name_Explorer"] + "_" + str(GlobalDictionaries.current_data["Game_Info"]["Dir_Curr"]) + "_" + Global.Player["Animation"]
		var curr_anim = $AnimationPlayer.current_animation

		if curr_anim != anim_name:
			$AnimationPlayer.play(anim_name)

#	if Global.Player["Animation"] != "Crouch" and Global.Player["Animation2"] == "Camera_Crouch":
#		Global.Player["Animation2"] = "Camera_Stand"

#	var anim_name = Global.Player["Animation2"]
#	var anim_curr = $AnimationPlayer2.current_animation
#	if anim_curr != anim_name:
#		$AnimationPlayer2.play(anim_name)

func _on_AnimationPlayer_animation_finished(anim_name):

	if anim_name.find("Spawn") != -1:
		$AnimationPlayer.play(Global.Player["Name_Explorer"] + "_1_Idle")
		Global.STATE_LEVEL = "Despawn_Portal"
		Global.STATE_PLAYER = "Move_Normal"
	elif anim_name.find("_Exit") != -1:
		Global.STATE_LEVEL = "Despawn_Portal_Exit"
	elif anim_name.find("_Interact") != -1:
		Global.STATE_PLAYER = "Move_Normal"
	elif anim_name.find("_Die") != -1:
		Global.STATE_PLAYER = "Dead"
#	elif anim_name.find("Scene") != -1:
#		Global.Player["Scenes"][Global.Player["Scenes"]["Scene_Curr"]["SceneName"]]["Seen"] = true
#		Global.STATE_GLOBAL = "Continue_Scene"
#	elif anim_name.find("_GoToHospital") != -1:
#		Global.STATE_LEVEL = "GoToHospital"
#	elif anim_name.find("_GoToMushRoom") != -1:
#		Global.STATE_LEVEL = "GoToMushRoom"
#	elif anim_name.find("_LeaveHospital") != -1:
#		Global.STATE_PLAYER = "Move_Normal"
#	elif anim_name.find("_LeaveMushRoom") != -1:
#		Global.STATE_PLAYER = "Move_Normal"
#	elif anim_name.find("_PlaceJumpshroom") != -1:
#		GlobalDictionaries.current_data["Item_Data"][GlobalDictionaries.current_data["Item_Placing"]]["Pos"] = self.position
#		GlobalDictionaries.current_data["Item_Data"][GlobalDictionaries.current_data["Item_Placing"]]["Level"] = GlobalDictionaries.game["Level_Current"]
#		Global.place_jumpshroom(get_parent().get_node("Items"), GlobalDictionaries.current_data["Item_Placing"])
#		GlobalDictionaries.current_data["Item_Data"][GlobalDictionaries.current_data["Item_Placing"]]["InInventory"] = false
#		GlobalDictionaries.current_data["Inventory"]["Jumpshroom"] -= 1
#		Global.STATE_PLAYER = "Move_Normal"
#	elif anim_name.find("_PlaceHandle") != -1:
#		Global.items[Global.item_placing]["Level"] = Global.Player["Level_Current"]
#		Global.items[Global.item_placing]["InInventory"] = false
#		Global.inv_handle -= 1
#		Global.STATE_PLAYER = "Move_Normal"
##		Global.STATE_LEVEl = "Move_Normal"




