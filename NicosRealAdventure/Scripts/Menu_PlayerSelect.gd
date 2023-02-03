extends Control

var selector_curr = 0
var selector_locations = {0:605}



func _ready():
	
	var PlayersLoaded = 1
	var SelectorLocation = 142
	
	while PlayersLoaded <= GlobalDictionaries.players.size():
		selector_curr = 1
		var PlayerButton = load("res://Scenes/Interface/Menu_PlayerSelect_Button.tscn").instance()
		PlayerButton.fill_label(PlayersLoaded)
		selector_locations[PlayersLoaded] = SelectorLocation
		$PlayerScroll/CenterContainer/Players.add_child(PlayerButton)
		PlayersLoaded += 1
		SelectorLocation += 60
		
	$Selector.rect_position.y = selector_locations[selector_curr]


func _physics_process(delta):
	if Input.is_action_just_pressed("menu_down"):
		if selector_curr < GlobalDictionaries.players.size() and selector_curr != 0:
			selector_curr += 1
			_move_selector()
		elif selector_curr == GlobalDictionaries.players.size():
			selector_curr = 0
			_move_selector()
	
	elif Input.is_action_just_pressed("menu_up"):
		if selector_curr > 1:
			selector_curr -= 1
			_move_selector()
		elif selector_curr == 0:
			selector_curr = GlobalDictionaries.players.size()
			_move_selector()
	
	elif Input.is_action_just_pressed("menu_select"):
		if selector_curr == 0:
			get_tree().change_scene("res://Scenes/Interface/Menu_GameStart.tscn")
		else:
			GlobalDictionaries.game["PlayerKey"] = str(selector_curr)
			Global.Player = GlobalDictionaries.players[str(GlobalDictionaries.game["PlayerKey"])]
			get_tree().change_scene("res://Scenes/Interface/Menu_LevelSelect.tscn")

func _move_selector():
	get_node("Selector").rect_position.y = selector_locations[selector_curr]

#	for PlayerDict in Global.players:
#		if PlayersLoaded < Global.players.size:
#			var PlayerButton = load("res://Scenes/Interface/PlayerSelectButton.tscn").instance()
#			PlayerButton.fill_label(PlayerDict)
#
#			PlayersLoaded += 1
#	var lvl_count = 0
#	for level_dict in PlayerVariables.level_dicts:
#		if lvl_count < PlayerVariables.player_stats["max_level"]:
#			var lvl_option = load("res://Scenes/LevelSelectLvl1.tscn").instance()
#			lvl_option.fill_label(level_dict["lvl_name"], level_dict["lvl_coins"], level_dict["lvl_max_coins"])
#			$LevelSelectCenter/LevelSelect/LevelSelectPanel/LevelSelectScroll/LevelSelectCenter/LevelSelectLevels.add_child(lvl_option)
#			lvl_count += 1

