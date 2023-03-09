extends CanvasLayer


func _ready():
	$PauseScreen.visible = false
#	$Items/Item_Select.visible = false
#	$Items/Item_Window.visible = false


func _process(delta):
	
	self.set_interface_coins()


func set_interface_coins():
	$Coin/Coin_Count_Label.text = str(GlobalDictionaries.current_data["Coins_Current"])
