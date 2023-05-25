extends Node2D
#
## ------ State Descripitons ------ 
#
##Spawn_Portal_Enter: Starts Animation "Portal_Spawn" on Portal_Enter swithces STATE_LEVEL to Portal_Spawning
#
##Portal_Spawning: doesn't trigger anything allowing "Portal_Spawn" animation to finish
#
##Spawn_Player: triggered when "Portal_Spawn" animation finishes on Player.gd switches STATE_PLAYER to "Spawn_Player"
#
##Player_Spawning: doesn't trigger anything allowing Player's Spawn animation to finish
#
##Despawn_Portal: triggered when Player's Spawn animation completes. Triggers "Portal_Close" animation on Portal_Enter. 
##	if there is a Portal_Exit it Switches STATE_LEVEL to Spawn_Portal_Exit else is switches STATE_LEVEL to Gameplay
#
##Spawn_Portal_Exit: triggers Portal_Spawn animation; Switches STATE_LEVEL to Gameplay
#
##Gameplay: State that should be active when on a level and other level things aren't happening
#
##Player_DeSpawning: doesn't trigger anything allowing Player's "Exit" animation to complete 
#
##Despawn_Portal_Exit: triggered when Player's "Exit" animation is complete. triggers "Portal_Close" animation on Portal_Exit.
##	Switches STATE_LEVEL to Gameplay
#

@export var cam_left = 0
@export var cam_right = 0
@export var cam_top = 0
@export var cam_bottom = 0

var level_num

func _ready():
	
	level_setup()

func _process(delta):
	pass


func level_setup():

	level_num = int(self.name.replace("Level_", ""))
	Global.Level = Global.Player["Levels"][str(level_num)]
	if get_node("Background").has_node("Portal_Enter"):
		$Player/AnimationPlayer.play("RESET")
		Global.STATE_LEVEL = "Portal_Enter_Open"
	else: 
		Global.STATE_LEVEL = "Gameplay"
		Global.STATE_PLAYER = "Move_Normal"
		
	level_setup_camera_limit()
#	level_setup_timer()
	level_setup_coins()
	level_setup_chests()
#	level_setup_gems()
	GlobalDictionaries.load_current_data()
#	level_setup_items()

func level_setup_camera_limit():

	$Player/Camera2D.limit_left = cam_left
	$Player/Camera2D.limit_right = cam_right
	$Player/Camera2D.limit_top = cam_top
	$Player/Camera2D.limit_bottom = cam_bottom

func level_setup_coins():

	var level_coins_count = get_tree().get_nodes_in_group("Coins").size()
	var dict_coins_count = Global.Level["Coins"].size()
	var Coin_Curr = 1

	if level_coins_count != dict_coins_count:
		Global.Level["Coins"] = []
		while Coin_Curr <= level_coins_count:
			Global.Level["Coins"].append(true)
			Coin_Curr += 1

	var Coins = Global.Level["Coins"]
	Coin_Curr = 1

	while Coin_Curr <= level_coins_count:
		get_node("Treasure/Coin" + str(Coin_Curr)).visible = Coins[Coin_Curr - 1]
		Coin_Curr += 1

func level_setup_chests():

	var level_chests_count = get_tree().get_nodes_in_group("Chests").size()
	var dict_chests_count = Global.Level["Chests"].size()
	var Chest_Curr = 1

	if level_chests_count != dict_chests_count:
		Global.Level["Chests"] = []
		while Chest_Curr <= level_chests_count:
			Global.Level["Chests"].append(true)
			Chest_Curr += 1

	var Chests = Global.Level["Chests"]
	Chest_Curr = 1

	while Chest_Curr <= level_chests_count:
		if Chests[Chest_Curr - 1]:
			get_node("Treasure/Chest" + str(Chest_Curr)).STATE = "Closed"
		else:
			get_node("Treasure/Chest" + str(Chest_Curr)).STATE = "Opened"
		Chest_Curr += 1
