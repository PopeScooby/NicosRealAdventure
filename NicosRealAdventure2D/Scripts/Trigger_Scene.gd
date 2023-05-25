extends Area2D

@export var scene_name = ""

func _ready():
	pass 


func _process(delta):
	pass


func _on_body_entered(body):
	if body.name == "Player" and Global.Player["Scenes"][scene_name]["Seen"] == false:
		Global.STATE_GLOBAL = "Play_Scene"
		Global.Player["Scenes"]["Scene_Curr"]["SceneName"] = scene_name
