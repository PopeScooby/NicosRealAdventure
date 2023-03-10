extends StaticBody2D

@export var coins_in_chest = 10
@onready var gameplay_interface = get_parent().get_parent().get_node("GameplayInterface")

var STATE = "Closed"

var chest_name
var chest_idx

func _ready():
	
	self.add_to_group("Chests")

	chest_name = self.name
	chest_idx = int(chest_name.replace("Chest","")) - 1

func _process(delta):
	if Global.STATE_PLAYER == "Chest_Opening" and STATE == "Closed" and GlobalDictionaries.current_data["Game_Info"]["Object_Interact"] == chest_name:
		STATE = "Opening"
		$AnimationPlayer.play("Chest_Open")
	elif STATE == "Opened":
		$AnimationPlayer.play("Chest_Opened")
	elif STATE == "Closed":
		$AnimationPlayer.play("Chest_Closed")


func _on_area_2d_can_open_body_entered(body):
	
	if body.name == "Player" and Global.Level["Chests"][chest_idx] == true:
		if body.position.x > self.position.x:
			GlobalDictionaries.current_data["Flags"]["Crate_R"] = true
		else:
			GlobalDictionaries.current_data["Flags"]["Crate_R"] = false
		GlobalDictionaries.current_data["Game_Info"]["Object_Interact"] = chest_name
		GlobalDictionaries.current_data["Flags"]["Can_OpenChest"] = true

func _on_area_2d_can_open_body_exited(body):

	if body.name == "Player":
		GlobalDictionaries.current_data["Flags"]["Can_OpenChest"] = false

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Chest_Open":
		$AnimationPlayer.play("Chest_Opened")
		_on_chest_opened()

func _on_chest_opened():
	Global.audio_players["ChestCollection"].play(0)
	GlobalDictionaries.current_data["Chests"][chest_idx] = false
	
	#Remove when Collected Coin fixed
	GlobalDictionaries.current_data["Coins_Current"] += self.coins_in_chest
	GlobalDictionaries.current_data["Coins_Total"] += self.coins_in_chest
	GlobalDictionaries.current_data["Coins_Level"] += self.coins_in_chest
	
#	for i in range(self.coins_in_chest):
#		var collected_coin: Control = load("res://Scenes/Items/Coin_Collected.tscn").instance()
#
#		var coin_sprite: AnimatedSprite = collected_coin.get_node("CoinSprite")
#		var coin_origin = coin_sprite.get_transform().get_origin() * .5
#		var origin: Vector2 = $Sprite.get_global_transform_with_canvas().get_origin() - coin_origin
#
#		# Hack - This is just copied from the Coin sprite 
#		collected_coin.rect_scale = Vector2(0.374, 0.374)
#		collected_coin.rect_global_position = origin
#
#		self.gameplay_interface.add_child(collected_coin)
#		collected_coin.animate()
#
#		# Increment coin count when the coin exits the tree (i.e. when it reaches the coin count HUD)
#		collected_coin.connect("tree_exiting", self, "_increment_coin_counts")
#
#		# Stagger coin animations to create a "stream" of coins
#		yield(get_tree().create_timer(.05), "timeout")
	
