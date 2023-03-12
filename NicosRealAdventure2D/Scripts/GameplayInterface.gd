extends CanvasLayer

var heart = load("res://Textures/Interface/Heart/Heart.png")
var heart_container = load("res://Textures/Interface/Heart/Heart_Empty.png")


func _ready():
	$PauseScreen.visible = false
#	$Items/Item_Select.visible = false
#	$Items/Item_Window.visible = false


func _process(delta):
	
	self.set_interface_coins()
	self.set_interface_hearts()


func set_interface_coins():
	$Coin/Coin_Count_Label.text = str(GlobalDictionaries.current_data["Coins_Current"])

func set_interface_hearts():
	
	if GlobalDictionaries.current_data["Hearts_Total"] < 5:
		$Hearts/Heart5.visible = false
	else:
		$Hearts/Heart5.visible = true
	if GlobalDictionaries.current_data["Hearts_Total"] < 4:
		$Hearts/Heart4.visible = false
	else:
		$Hearts/Heart4.visible = true
	if GlobalDictionaries.current_data["Hearts_Total"] < 3:
		$Hearts/Heart3.visible = false
	else:
		$Hearts/Heart3.visible = true
	if GlobalDictionaries.current_data["Hearts_Total"] < 2:
		$Hearts/Heart2.visible = false
	else:
		$Hearts/Heart2.visible = true
	if GlobalDictionaries.current_data["Hearts_Total"] < 1:
		$Hearts/Heart1.visible = false
	else:
		$Hearts/Heart1.visible = true

	for x in 6:
		if x != 0:
			var HeartNode = get_node("Hearts/Heart" + str(x))

			if GlobalDictionaries.current_data["Hearts_Total"] < x:
				HeartNode.visible = false

			if GlobalDictionaries.current_data["Hearts_Current"] < x:
				HeartNode.texture = heart_container
			else:
				HeartNode.texture = heart
