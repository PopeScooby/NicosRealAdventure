extends Area2D


func _ready():
	pass # Replace with function body.


func _on_HospitalDoor_body_entered(body):
	if body.name == "Adventurer":
		GlobalDictionaries.current_data["Flags"]["On_Hospital"] = true


func _on_HospitalDoor_body_exited(body):
	if body.name == "Adventurer":
		GlobalDictionaries.current_data["Flags"]["On_Hospital"] = false
