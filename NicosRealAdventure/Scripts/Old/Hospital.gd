extends Control

export var curr_scene = ""

var selector_curr = 1
var selector_locations = {1:{"Position":Vector2(271,453),
							 "Size":Vector2(153,75)}, 
						  2:{"Position":Vector2(100,267),
							 "Size":Vector2(193,163)}, 
						  3:{"Position":Vector2(411.25,267),
							 "Size":Vector2(193,163)}}

func _ready():
	pass

func _process(delta):
	
	if GlobalDictionaries.current_data["Item_Data"]["HeartContainer1"]["Purchased"] == false and $SidePanel.visible == true:
		$SidePanel/HeartContainer.visible = true
	else:
		$SidePanel/HeartContainer.visible = false
	
	
	if Global.STATE_LEVEL == "InHospital" and curr_scene != "" and self.visible == true and $ContinueLabel.visible == false and $SidePanel.visible == false:
		$AnimationPlayer.play(curr_scene)
	elif Input.is_action_just_pressed("menu_select") and $ContinueLabel.visible == true:
		$SpeechBubble.visible = false
		$ContinueLabel.visible = false
		$SidePanel.visible = true
	elif Input.is_action_just_pressed("menu_select") and $SidePanel.visible == true:
		if selector_curr == 1:
			exit_hospital()
		elif selector_curr == 2:
			buy_heart_container()
		elif selector_curr == 3:
			buy_heart()

	elif Input.is_action_just_pressed("menu_up") and $SidePanel.visible == true and selector_curr == 1:
		selector_curr = 2
		self.move_selector()
	elif Input.is_action_just_pressed("menu_down") and $SidePanel.visible == true and (selector_curr == 2 or selector_curr == 3):
		selector_curr = 1
		self.move_selector()
	elif Input.is_action_just_pressed("menu_right") and $SidePanel.visible == true and (selector_curr == 2 or selector_curr == 1):
		selector_curr = 3
		self.move_selector()
	elif Input.is_action_just_pressed("menu_left") and $SidePanel.visible == true and (selector_curr == 3 or selector_curr == 1):
		selector_curr = 2
		self.move_selector()
	


func move_selector():
	$SidePanel/Selector.rect_position = selector_locations[selector_curr]["Position"]
	$SidePanel/Selector.rect_size = selector_locations[selector_curr]["Size"]

func buy_heart_container():
	if GlobalDictionaries.current_data["Coins_Current"] >= 50 and GlobalDictionaries.current_data["Item_Data"]["HeartContainer1"]["Purchased"] == false:
		GlobalDictionaries.current_data["Hearts_Total"] += 1
		GlobalDictionaries.current_data["Hearts_Current"] += 1
		GlobalDictionaries.current_data["Coins_Current"] -= 50
		GlobalDictionaries.current_data["Item_Data"]["HeartContainer1"]["Purchased"] = true
	
	

func buy_heart():
	if GlobalDictionaries.current_data["Hearts_Current"] < GlobalDictionaries.current_data["Hearts_Total"] and GlobalDictionaries.current_data["Coins_Current"] >= 10:
		GlobalDictionaries.current_data["Hearts_Current"] += 1
		GlobalDictionaries.current_data["Coins_Current"] -= 10


func exit_hospital():
	Global.STATE_LEVEL = "ExitHospital"

