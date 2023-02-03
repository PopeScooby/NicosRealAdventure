extends Control

var selector_curr = 0
var selector_locations = {0:605}



func _ready():
	
	var LevelsLoaded = 1
	var SelectorLocation = 142
	var Level_Max = Global.Player["Level_Max"]
	
	while LevelsLoaded <= Level_Max:
		selector_curr = LevelsLoaded
		var LevelButton = load("res://Scenes/Interface/Menu_LevelSelect_Button.tscn").instance()
		LevelButton.fill_label(LevelsLoaded)
		selector_locations[LevelsLoaded] = SelectorLocation
		$LevelScroll/CenterContainer/Levels.add_child(LevelButton)
		LevelsLoaded += 1
		SelectorLocation += 60
		
	$Selector.rect_position.y = selector_locations[selector_curr]


func _physics_process(delta):
	
	var Level_Max = Global.Player["Level_Max"]
	
	if Input.is_action_just_pressed("menu_down"):
		if selector_curr < Level_Max and selector_curr != 0:
			selector_curr += 1
			_move_selector()
		elif selector_curr == Level_Max:
			selector_curr = 0
			_move_selector()
	
	elif Input.is_action_just_pressed("menu_up"):
		if selector_curr > 1:
			selector_curr -= 1
			_move_selector()
		elif selector_curr == 0:
			selector_curr = Level_Max
			_move_selector()
	
	elif Input.is_action_just_pressed("menu_select"):
		if selector_curr == 0:
			get_tree().change_scene("res://Scenes/Interface/Menu_PlayerSelect.tscn")
		else:
			GlobalDictionaries.game["Level_Current"] = selector_curr
			Global.load_level()

func _move_selector():
	get_node("Selector").rect_position.y = selector_locations[selector_curr]
