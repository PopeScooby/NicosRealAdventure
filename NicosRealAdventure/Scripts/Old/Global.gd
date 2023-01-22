extends Node

#var isDebug = false

var Player
var Level

var audio_players = {}

var STATE_GLOBAL = "GameStart"
var STATE_PLAYER = ""
var STATE_LEVEL = ""

func _ready():
	load_audio()
	load_saves()

func _process(delta):
	pass

func load_audio():
	for file_name in ["CoinCollection", "RubyCollection", "TreasureCollection", "Click", "Bounce"]:
		var stream = load("res://Audio/%s.mp3" % file_name)	
		Global.audio_players[file_name] = AudioStreamPlayer.new()
		Global.audio_players[file_name].set_stream(stream)
		add_child(Global.audio_players[file_name])
		

func load_saves():
	
	var save_game = File.new()
	var file_name = "user://save_data.save"
	if not save_game.file_exists(file_name):
		return
	
	save_game.open(file_name, File.READ)
	GlobalDictionaries.players.clear()
	while not save_game.eof_reached():
		var current_line = parse_json(save_game.get_line())
		if current_line!= null:
			GlobalDictionaries.players = current_line

	save_game.close()

func load_new_game(PlayerName):
	
	load_new_palyer(PlayerName)
	save_game()
	get_tree().change_scene("res://Scenes/Interface/HomeBase.tscn")

func load_new_palyer(PlayerName):
	
	var NewPlayerKey
	if GlobalDictionaries.players.has("1"):
		NewPlayerKey = str(GlobalDictionaries.players.size() + 1)
	else:
		NewPlayerKey = "1"
	
	GlobalDictionaries.game["PlayerKey"] = NewPlayerKey
	GlobalDictionaries.players[str(NewPlayerKey)] = GlobalDictionaries.get_new_player_dict(PlayerName)
	self.Player = GlobalDictionaries.players[NewPlayerKey]

func load_level():

	var Level_Suffix = "0" + str(GlobalDictionaries.game["Level_Current"])
	get_tree().change_scene("res://Scenes/Levels/Level_" + Level_Suffix + ".tscn")

func save_game():
	
	var save_game = File.new()
	var file_name = "user://save_data.save"
	
	save_game.open(file_name, File.WRITE)
	save_game.store_line(to_json(GlobalDictionaries.players))
	save_game.close()

func place_jumpshroom(ItemsNode, JumpshroomName):
	var jumpshroom = load("res://Scenes/Items/Jumpshroom.tscn").instance()
	jumpshroom.position = GlobalDictionaries.current_data["Item_Data"][JumpshroomName]["Pos"]
	jumpshroom.scale = Vector2(2,2)
	jumpshroom.BounceHeight = -3000
	ItemsNode.add_child(jumpshroom)
