extends Area2D

func _ready():
	pass 

func _on_Vines_body_entered(body):

	if body.name == "Player":
		GlobalDictionaries.current_data["Flags"]["On_Vines"] = true

func _on_Vines_body_exited(body):

	if body.name == "Player":
		GlobalDictionaries.current_data["Flags"]["On_Vines"] = false

