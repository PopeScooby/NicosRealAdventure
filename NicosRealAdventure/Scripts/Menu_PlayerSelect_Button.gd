extends Button


func _ready():
	pass 

func fill_label(PlayerKey):
	
	Global.Player = GlobalDictionaries.players[str(PlayerKey)]
	
	self.text = str(PlayerKey) + ". " + Global.Player["Name"] + " - Level: " + str(Global.Player["Level_Max"]) + "; Coins: " + str(Global.Player["Coins"]) + "; Hearts: " + str(Global.Player["Hearts"])
