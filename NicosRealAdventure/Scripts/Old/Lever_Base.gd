extends Area2D

export (NodePath) var Lever_Path

var Lever_Name


func _ready():
	Lever_Name = self.name


func _process(delta):
	if Input.is_action_just_pressed("action_interact") and GlobalDictionaries.current_data["Flags"]["Near_LeverBase"] == true and GlobalDictionaries.current_data["Current_Item"] == "Handle" and GlobalDictionaries.current_data["Game_Info"]["Object_Interact"] == self.name and self.visible and GlobalDictionaries.current_data["Inventory"]["Handle"] > 0:
		var Complete_Lever = get_node(Lever_Path)
		Complete_Lever.visible = true
		self.visible = false
		GlobalDictionaries.current_data["Inventory"]["Handle"] -= 1

func _on_Lever_Base_body_entered(body):
	if body.name == "Adventurer" and self.visible:
		GlobalDictionaries.current_data["Game_Info"]["Object_Interact"] = Lever_Name
		GlobalDictionaries.current_data["Flags"]["Near_LeverBase"] = true


func _on_Lever_Base_body_exited(body):
	if body.name == "Adventurer":
		GlobalDictionaries.current_data["Game_Info"]["Object_Interact"] = Lever_Name
		GlobalDictionaries.current_data["Flags"]["Near_LeverBase"] = false
