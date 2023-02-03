extends Area2D
#
#export var flow_dir = 1
#export var flow_speed = 150

func _ready():
	pass 

func _on_Vines_body_entered(body):

	if body.name == "Adventurer":
		GlobalDictionaries.current_data["Flags"]["On_Vines"] = true

func _on_Vines_body_exited(body):

	if body.name == "Adventurer":
		GlobalDictionaries.current_data["Flags"]["On_Vines"] = false

