extends CanvasLayer

var heart = load("res://Textures/Items/Heart.png")
var heart_container = load("res://Textures/Items/Heart_Empty.png")

var selector_curr = 1
var selector_locations = {1:270, 2:330, 3:400}

func _ready():
	$PauseScreen.visible = false

func _on_LevelTimeTimer_timeout():
	if GlobalDictionaries.current_data["Level_Timer"] > 0:
		$Timer/LevelTimeTimer.start()
		GlobalDictionaries.current_data["Level_Timer"] -= 1

func _process(delta):
	
	if Global.STATE_PLAYER == "Dead":
		$PauseScreen/PauseLbl.text = "You are Dead!"
		exec_state_pause()
	elif Global.STATE_PLAYER == "Timeout":
		$PauseScreen/PauseLbl.text = "Out Of Time!"
		exec_state_pause()
	elif Global.STATE_LEVEL == "GoToHospital":
		exec_state_go_to_hospital()
	elif Global.STATE_LEVEL == "ExitHospital":
		exec_state_exit_hospital()
	elif Global.STATE_LEVEL == "GoToMushRoom":
		exec_state_go_to_mush_room()
	elif Global.STATE_LEVEL == "ExitMushRoom":
		exec_state_exit_mush_room()
	elif Global.STATE_PLAYER == "Start_Scene":
		exec_state_start_scene()
	elif Global.STATE_PLAYER == "Complete_Scene":
		exec_state_complete_scene()
	else:
		$PauseScreen/PauseLbl.text = "~Pause~"
	
	$Timer/LevelTimeLbl.text = str(GlobalDictionaries.current_data["Level_Timer"])

	if Input.is_action_just_pressed("pause") and get_tree().paused == true and Global.STATE_PLAYER != "Dead":
		exec_state_unpause()
	elif Input.is_action_just_pressed("pause") and get_tree().paused == false and Global.STATE_PLAYER != "Dead":
		exec_state_pause()
	elif $PauseScreen.visible == true:
		exec_state_menu()
		
		
	$Coin/Coin_Count_Label.text = str(GlobalDictionaries.current_data["Coins_Current"])
	
	if GlobalDictionaries.current_data["Hearts_Total"] < 5:
		$Hearts/Heart5.visible = false
	else:
		$Hearts/Heart5.visible = true
	if GlobalDictionaries.current_data["Hearts_Total"] < 4:
		$Hearts/Heart4.visible = false
	else:
		$Hearts/Heart4.visible = true
	if GlobalDictionaries.current_data["Hearts_Total"] < 3:
		$Hearts/Heart3.visible = false
	else:
		$Hearts/Heart3.visible = true
	if GlobalDictionaries.current_data["Hearts_Total"] < 2:
		$Hearts/Heart2.visible = false
	else:
		$Hearts/Heart2.visible = true
	if GlobalDictionaries.current_data["Hearts_Total"] < 1:
		$Hearts/Heart1.visible = false
	else:
		$Hearts/Heart1.visible = true
#
	for x in 6:
		if x != 0:
			var HeartNode = get_node("Hearts/Heart" + str(x))

			if GlobalDictionaries.current_data["Hearts_Total"] < x:
				HeartNode.visible = false

			if GlobalDictionaries.current_data["Hearts_Current"] < x:
				HeartNode.texture = heart_container
			else:
				HeartNode.texture = heart
				
	var item_texture = "res://Textures/Interface/Item_" + GlobalDictionaries.current_data["Current_Item"] + ".png"
	var item_image = load(item_texture)
	$Items/ItemWindow/ItemImg.texture = item_image
	if GlobalDictionaries.current_data["Current_Item"] == "Empty":
		$Items/ItemWindow/ItemImg/Item_Count_Label.visible = false
		$Items/ItemWindow/ItemImg/Item_x_Label.visible = false
	else:
		$Items/ItemWindow/ItemImg/Item_Count_Label.visible = true
		$Items/ItemWindow/ItemImg/Item_Count_Label.text = str(GlobalDictionaries.current_data["Inventory"][GlobalDictionaries.current_data["Current_Item"]])
		$Items/ItemWindow/ItemImg/Item_x_Label.visible = true
		

func exec_state_pause():
	get_tree().paused = true
	$Timer/LevelTimeTimer.stop()
	$PauseScreen.visible = true

func exec_state_unpause():
	get_tree().paused = false
	$Timer/LevelTimeTimer.start()
	$PauseScreen.visible = false

func exec_state_menu():
	if Input.is_action_just_pressed("menu_down") and selector_curr != 0:
		if selector_curr != 3:
			selector_curr += 1
			_move_selector()
	
	elif Input.is_action_just_pressed("menu_up") and selector_curr != 0:
		if selector_curr != 1:
			selector_curr -= 1
			_move_selector()
	
	elif Input.is_action_just_pressed("menu_select"):
		if selector_curr == 1:			
			exec_state_unpause()
			GlobalDictionaries.load_current_data()
			Global.load_level()
			Global.STATE_GLOBAL = ""
			Global.STATE_PLAYER = ""
		elif selector_curr == 2:
			exec_state_unpause()
			get_tree().change_scene("res://Scenes/Interface/Menu_LevelSelect.tscn")
		elif selector_curr == 3:
			get_tree().quit()
	
	elif Input.is_action_just_pressed("menu_back"):
		exec_state_unpause()

func exec_state_go_to_hospital():
	get_tree().paused = true
	$Timer/LevelTimeTimer.stop()
	$Hospital.visible = true
	$Hospital.curr_scene = "Scene_Hospital_01"
	Global.STATE_LEVEL = "InHospital"

func exec_state_exit_hospital():
	$Hospital.visible = false
	Global.STATE_LEVEL = "Gameplay"
	Global.STATE_PLAYER = "ExitHospital"
	get_tree().paused = false
	$Timer/LevelTimeTimer.start()

func exec_state_go_to_mush_room():
	get_tree().paused = true
	$Timer/LevelTimeTimer.stop()
	$MushRoom.visible = true
	$MushRoom.curr_scene = "Scene_MushRoom_01"
	Global.STATE_LEVEL = "InMushRoom"

func exec_state_exit_mush_room():
	$MushRoom.visible = false
	Global.STATE_LEVEL = "Gameplay"
	Global.STATE_PLAYER = "ExitMushRoom"
	get_tree().paused = false
	$Timer/LevelTimeTimer.start()
	
func exec_state_start_scene():
	if Global.Player["Scenes"][Global.Player["Scenes"]["Scene_Curr"]["SceneName"]]["Parent"] == "GameplayInterface":
		var anim_name = "Scene_" + Global.Player["Scenes"]["Scene_Curr"]["SceneName"]
		$Radio/AnimationPlayer.play(anim_name)
	else:
		$Radio.visible = false

func exec_state_complete_scene():
	$Radio.visible = false
	if Global.Player["Scenes"][Global.Player["Scenes"]["Scene_Curr"]["SceneName"]]["Parent"] == "GameplayInterface":
		Global.Player["Scenes"][Global.Player["Scenes"]["Scene_Curr"]["SceneName"]]["Seen"] = true
		Global.STATE_PLAYER = "Move_Normal"


#func exec_state_timeout():
#	get_tree().paused = true
#	$Timer/LevelTimeTimer.stop()
#	$PauseScreen.visible = true

func _move_selector():
	$PauseScreen/Selector.rect_position.y = selector_locations[selector_curr]





func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name.find("Scene") != -1:
		Global.Player["Scenes"][Global.Player["Scenes"]["Scene_Curr"]["SceneName"]]["Seen"] = true
		Global.STATE_GLOBAL = "Continue_Scene"
