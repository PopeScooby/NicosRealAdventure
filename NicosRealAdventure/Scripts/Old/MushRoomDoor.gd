extends Area2D

func _ready():
	pass # Replace with function body.

func _on_MushRoomDoor_body_entered(body):
	if body.name == "Adventurer":
		Global.Player["Player_Flags"]["On_MushRoom"] = true


func _on_MushRoomDoor_body_exited(body):
	if body.name == "Adventurer":
		Global.Player["Player_Flags"]["On_MushRoom"] = false
