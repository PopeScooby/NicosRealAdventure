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
	if Global.STATE_PLAYER == "Move_Normal":
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
		
		if velocity.y < 0:
			Global.Player["Animation"] = "Jump"
		else:
			Global.Player["Animation"] = "Fall"
		
	else:
		if velocity.x == 0:
			Global.Player["Animation"] = "Idle"
		else:
			Global.Player["Animation"] = "Run"
		
	
	if Input.get_axis("move_left", "move_right"):
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

#const SPEED = 300.0
#const JUMP_VELOCITY = -400.0
#
## Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

#	# Add the gravity.
#	if not is_on_floor():
#		velocity.y += gravity * delta
#
#	# Handle Jump.
#	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
#		velocity.y = JUMP_VELOCITY
#
#	# Get the input direction and handle the movement/deceleration.
#	# As good practice, you should replace UI actions with custom gameplay actions.
#	var direction = Input.get_axis("move_left", "move_right")
#	if direction:
#		velocity.x = direction * SPEED
#	else:
#		velocity.x = move_toward(velocity.x, 0, SPEED)
#
#	move_and_slide()
