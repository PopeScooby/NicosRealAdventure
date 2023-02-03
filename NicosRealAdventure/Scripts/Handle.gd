extends Area2D

var Handle_Name 


func _ready():
	Handle_Name = self.name
	
	if Global.items[Handle_Name]["InInventory"] or Global.items[Handle_Name]["Level"] != 0:
		queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Handle_body_entered(body):
	if body.name == "Adventurer":
		GlobalDictionaries.current_data["Item_Data"]["Handle1"]["InInventory"] = true
		GlobalDictionaries.current_data["Inventory"]["Handle"] += 1
		queue_free()
