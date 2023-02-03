extends Node


func _ready():
	pass 

func _process(delta):
	if Global.STATE_GLOBAL == "Play_Scene":
		Global.STATE_PLAYER = "Start_Scene"
		Global.STATE_LEVEL = "Playing_Scene"
		
	elif Global.STATE_GLOBAL == "Continue_Scene":
		Global.STATE_LEVEL = "Continue_Scene"
		
	elif Global.STATE_GLOBAL == "Continuing_Scene":
		
		var this_scene = Global.Player["Scenes"]["Scene_Curr"]["SceneName"]
		var next_scene = Global.Player["Scenes"][this_scene]["Next"]

		if next_scene != "":
			Global.Player["Scenes"]["Scene_Curr"]["SceneName"] = next_scene
			Global.STATE_GLOBAL = "Play_Scene"
		else:
			Global.STATE_LEVEL = "Complete_Scene"
			Global.STATE_PLAYER = "Complete_Scene"


#					 "Scenes": {"Scene_Curr":{ "SceneName": ""},
#								"New_Game": {"Seen": false, "Next": ""},
#								"Level_01_Enter": {"Seen": false, "Next": ""}}
