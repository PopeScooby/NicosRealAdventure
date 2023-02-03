extends Control

var curr_scene = 0

func _ready():
	Global.Player["Scenes"]["Scene_Curr"]["SceneName"] = "Homebase_Intro_01"
	Global.STATE_GLOBAL = "Play_Scene"


func _process(delta):
	if Global.STATE_GLOBAL == "Play_Scene":
		
		if $Character_Select.visible == true:
			Global.STATE_GLOBAL = "To_CharacterSelect"
		else:
			exec_state_start_scene()
			Global.STATE_GLOBAL = "Playing_Scene"
	
	elif Input.is_action_just_pressed("menu_select") and Global.STATE_GLOBAL == "Scene_Waiting" and $Speech/Selector.visible == true and $Character_Select.visible == false:
	
		var this_scene = Global.Player["Scenes"]["Scene_Curr"]["SceneName"]
		var next_scene = Global.Player["Scenes"][this_scene]["Next"]
		
		Global.Player["Scenes"][this_scene]["Seen"] = true
		
		if next_scene != "":
			Global.Player["Scenes"]["Scene_Curr"]["SceneName"] = next_scene
			exec_state_start_scene()
		else:
			if Global.Player["Name_Explorer"] == "":
				$Character_Select.visible = true
				Global.STATE_GLOBAL = "To_CharacterSelect"
			else:
				Global.STATE_GLOBAL = ""
				Global.STATE_PLAYER = ""
				Global.save_game()
				GlobalDictionaries.game["Level_Current"] = 1
				Global.load_level()


func exec_state_start_scene():
	var anim_name = Global.Player["Scenes"]["Scene_Curr"]["SceneName"]
	$AnimationPlayer.play(anim_name)

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name.find("Homebase_Intro") != -1:
		Global.STATE_GLOBAL = "Scene_Waiting"


