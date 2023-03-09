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
func _ready():
	set_player()

func _physics_process(delta):
	check_state()
	exec_state(delta)

func check_state():
	pass

func exec_state(delta):
	if Global.STATE_PLAYER == "Bounce":
		exec_state_bounce()
	elif Global.STATE_PLAYER == "Move_Normal":
		exec_state_move(delta)


func set_player():
	if Global.is_debug:
		GlobalDictionaries.players["1"] = GlobalDictionaries.get_new_player_dict("Debug")
		Global.Player = GlobalDictionaries.players["1"]
		Global.Player["Name_Explorer"] = "Nico"
		GlobalDictionaries.game["PlayerKey"] = "1"
		GlobalDictionaries.game["Level_Current"] = int(get_parent().name.replace("Level_",""))
		Global.Player["Level_Max"] = int(get_parent().name.replace("Level_",""))
		Global.STATE_PLAYER = "Move_Normal"
	else:
		Global.Player = GlobalDictionaries.players[str(GlobalDictionaries.game["PlayerKey"])]
		

func exec_state_move(delta):

	if not is_on_floor():
		velocity.y += GlobalDictionaries.current_data["Game_Info"]["Gravity"] * delta
		get_animation_y()
		
	else:
		get_animation_x()
	
	
	if Input.is_action_just_pressed("action_interact") and GlobalDictionaries.current_data["Flags"]["Can_OpenChest"] == true:
		exec_state_open_chest()
		
	elif Input.get_axis("move_left", "move_right"):
		exec_state_move_horizontal(Input.get_axis("move_left", "move_right"))
	
	else:
		exec_state_move_idle()
	
	if is_on_floor():
		if Input.is_action_just_pressed("move_jump"):
			exec_state_move_jump()
	
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

func exec_state_move_jump():
	velocity.y = GlobalDictionaries.current_data["Game_Info"]["JumpHeight"]

func exec_state_open_chest():

	GlobalDictionaries.current_data["Flags"]["Can_OpenChest"] = false
	Global.STATE_PLAYER = "Chest_Opening"
	Global.Player["Animation"] = "Interact"

func exec_state_bounce():
	velocity.y = GlobalDictionaries.current_data["Interactions"]["Jumpshroom"]["BounceHeight"]
	Global.STATE_PLAYER = "Move_Normal"


func get_animation_y():
	
	if velocity.y < 0:
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


func set_animation():
	
	var anim_name = Global.Player["Name_Explorer"] + "_" + Global.Player["Animation"]
	var curr_anim = $AnimationPlayer.current_animation

	if curr_anim != anim_name:
		$AnimationPlayer.play(anim_name)

#	if Global.Player["Animation"] == "VinesIdle":
#		$AnimationPlayer.playback_speed = 0
#	else:
#		$AnimationPlayer.playback_speed = 1
#		var anim_name = Global.Player["Name_Explorer"] + "_" + Global.Player["Animation"]
#		var curr_anim = $AnimationPlayer.current_animation
#
#		if curr_anim != anim_name:
#			$AnimationPlayer.play(anim_name)



func _on_animation_player_animation_finished(anim_name):
	
	if anim_name.find("_Interact") != -1:
		Global.STATE_PLAYER = "Move_Normal"

