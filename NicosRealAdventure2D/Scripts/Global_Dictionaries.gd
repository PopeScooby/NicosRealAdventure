extends Node

var game = {
	"PlayerKey": "0",
	"Level_Current": 1
	}
	
var players = {}

var current_data = {}

var items = ["Empty"]

func _ready():
	pass 

func get_new_player_dict(PlayerName):
	
	var player_data = {
		"Name": PlayerName,
		"Name_Explorer": "",
		"Hearts_Current": 3,
		"Hearts_Total": 3,
		"Coins_Current": 0,
		"Coins_Total": 0,
		"Level_Max": 1,
		"Animation": "",
		"Animation2": "",
		"Current_Item": "Empty",
		"Item_Data": get_item_data_dict(),
		"Inventory": get_inventory_data(),
		"Levels" : get_levels_dict(),
		"Scenes": get_scenes_dict()
	}
	
	return player_data

func get_item_data_dict():
	return {
		"Jumpshroom1": {"Purchased": false, "InInventory": false, "Level": 0, "Pos": Vector2(0,0)}, 
		"Jumpshroom2": {"Purchased": false, "InInventory": false, "Level": 0, "Pos": Vector2(0,0)}, 
		"HeartContainer1": {"Purchased": false},
		"Handle1": {"Purchased": false, "InInventory": false, "Level": 0, "Lever_Base": ""}
	}

func get_inventory_data():
	return{
		"Empty": null, 
		"Jumpshroom": 0, 
		"Handle": 0
	}

func get_levels_dict():
	return{
		"0": get_level_dict(),
		"1": get_level_dict(),
		"2": get_level_dict(),
		"3": get_level_dict(),
		"4": get_level_dict(),
		"5": get_level_dict(),
		"6": get_level_dict(),
		"7": get_level_dict()
	}

func get_level_dict():
	return{
		"Timer": 0,
		"Coins_Collected": 0,
		"Coins": [],
		"Chests": [],
		"Gems": [],
		"Complete": false,
		"GotPerfect": false, 
		"Perfect_Time": null,
		"Treasure_Collected": false
	}

func get_scenes_dict():
	return{
		"Scene_Curr":{ "SceneName": ""},
		"Homebase_Intro_01": {"Seen": false, "Next": "Homebase_Intro_02", "Parent":"Homebase"},
		"Homebase_Intro_02": {"Seen": false, "Next": "Homebase_Intro_03", "Parent":"Homebase"},
		"Homebase_Intro_03": {"Seen": false, "Next": "Homebase_Intro_04", "Parent":"Homebase"},
		"Homebase_Intro_04": {"Seen": false, "Next": "Homebase_Intro_05", "Parent":"Homebase"},
		"Homebase_Intro_05": {"Seen": false, "Next": "Homebase_Intro_06", "Parent":"Homebase"},
		"Homebase_Intro_06": {"Seen": false, "Next": "Homebase_Intro_07", "Parent":"Homebase"},
		"Homebase_Intro_07": {"Seen": false, "Next": "Homebase_Intro_08", "Parent":"Homebase"},
		"Homebase_Intro_08": {"Seen": false, "Next": "", "Parent":"Homebase"},
		"Homebase_Intro_09": {"Seen": false, "Next": "Homebase_Intro_10", "Parent":"Homebase"},
		"Homebase_Intro_10": {"Seen": false, "Next": "", "Parent":"Homebase"},
		"Level_01_Enter": {"Seen": false, "Next": "Level_01_Radio_01", "Parent":"Adventurer"},
		"Level_01_Radio_01": {"Seen": false, "Next": "Level_01_Radio_02", "Parent":"GameplayInterface"},
		"Level_01_Radio_02": {"Seen": false, "Next": "", "Parent":"GameplayInterface"},
		"Level_01_2": {"Seen": false, "Next": "", "Parent":"Adventurer"},
		"Level_02_Enter_01": {"Seen": false, "Next": "Level_02_Enter_02", "Parent":"Adventurer"},
		"Level_02_Enter_02": {"Seen": false, "Next": "Level_02_Enter_03", "Parent":"Adventurer"},
		"Level_02_Enter_03": {"Seen": false, "Next": "Level_02_Enter_04", "Parent":"GameplayInterface"},
		"Level_02_Enter_04": {"Seen": false, "Next": "", "Parent":"GameplayInterface"},
		"Level_05_HospitalFound": {"Seen": false, "Next": "", "Parent":"Adventurer"},
		"Level_07_MushRoomFound": {"Seen": false, "Next": "", "Parent":"Adventurer"}
	}

func get_game_info_dict():
	return{
		"Friction": false,
		"Gravity": ProjectSettings.get_setting("physics/2d/default_gravity"),
		"Acceleration": 200,
		"SpeedMax": 800,
		"JumpHeight": -1800,
		"Dir_Curr": 1,
		"Dir_Prev": 1
		}

func get_player_flags():
	return{
		"Can_Climb": false,
		"On_Exit": false,
		"Can_OpenChest": false,
		"Can_Push": false,
		"Crate_R": false,
		"On_Elevator": false,
		"On_Vines": false,
		"On_Enemy": false,
		"On_Spikes": false,
		"On_Hospital": false,
		"Can_PullLever": false,
		"On_Crate": false,
		"On_MushRoom": false,
		"Near_LeverBase": false
		}


func load_current_data():
	self.current_data = {
		"Hearts_Current": Global.Player["Hearts_Current"],
		"Hearts_Total": Global.Player["Hearts_Total"],
		"Coins_Current": Global.Player["Coins_Current"],
		"Coins_Total": Global.Player["Coins_Total"],
		"Coins_Level": Global.Level["Coins_Collected"],
		"Level_Timer": Global.Level["Timer"],
		"Coins": [],
		"Chests": [],
		"Gems": [],
		"Current_Item": Global.Player["Current_Item"],
		"Item_Placing": "",
		"Interactions": {"Jumpshroom": {"BounceHeight": 0}},
		"Item_Data": get_item_data_dict(),
		"Inventory": get_inventory_data(),
		"Game_Info": get_game_info_dict(),
		"Flags": get_player_flags()
	}

	var curr_idx = 0
	while curr_idx < Global.Level["Coins"].size():
		self.current_data["Coins"].append(Global.Level["Coins"][curr_idx])
		curr_idx += 1

	curr_idx = 0
	while curr_idx < Global.Level["Chests"].size():
		self.current_data["Chests"].append(Global.Level["Chests"][curr_idx])
		curr_idx += 1
	
	self.current_data["Item_Data"]["Jumpshroom1"]["InInventory"] = Global.Player["Item_Data"]["Jumpshroom1"]["InInventory"]
	self.current_data["Item_Data"]["Jumpshroom1"]["Level"] = Global.Player["Item_Data"]["Jumpshroom1"]["Level"]
	self.current_data["Item_Data"]["Jumpshroom1"]["Pos"] = Global.Player["Item_Data"]["Jumpshroom1"]["Pos"]
	self.current_data["Item_Data"]["Jumpshroom2"]["InInventory"] = Global.Player["Item_Data"]["Jumpshroom2"]["InInventory"]
	self.current_data["Item_Data"]["Jumpshroom2"]["Level"] = Global.Player["Item_Data"]["Jumpshroom2"]["Level"]
	self.current_data["Item_Data"]["Jumpshroom2"]["Pos"] = Global.Player["Item_Data"]["Jumpshroom2"]["Pos"]
	
	self.current_data["Item_Data"]["HeartContainer1"]["Purchased"] = Global.Player["Item_Data"]["HeartContainer1"]["Purchased"]
	
	self.current_data["Inventory"]["Jumpshroom"] = Global.Player["Inventory"]["Jumpshroom"]
	self.current_data["Inventory"]["Handle"] = Global.Player["Inventory"]["Handle"]


func save_current_data():
	
	if Global.Level["Coins_Collected"] == 0 and self.current_data["Coins_Level"] == (self.current_data["Coins"].size() + (self.current_data["Chests"].size() * 10)) :
		Global.Level["GotPerfect"] = true
		var seconds_used = Global.Level["Timer"] - self.current_data["Level_Timer"] 
		Global.Level["Perfect_Time"] = str(floor(seconds_used / 60)) + ":" + str(seconds_used - (floor(seconds_used / 60) * 60))

	Global.Player["Hearts_Current"] = self.current_data["Hearts_Current"]
	Global.Player["Hearts_Total"] = self.current_data["Hearts_Total"]
	Global.Player["Coins_Current"] = self.current_data["Coins_Current"]
	Global.Player["Coins_Total"] = self.current_data["Coins_Total"]
	Global.Level["Coins_Collected"] = self.current_data["Coins_Level"]
	Global.Player["Current_Item"] = self.current_data["Current_Item"]
	
	var curr_idx = 0
	Global.Level["Coins"] = []
	while curr_idx < self.current_data["Coins"].size():
		Global.Level["Coins"].append(self.current_data["Coins"][curr_idx])
		curr_idx += 1

	curr_idx = 0
	Global.Level["Chests"] = []
	while curr_idx < self.current_data["Chests"].size():
		Global.Level["Chests"].append(self.current_data["Chests"][curr_idx])
		curr_idx += 1

	Global.Player["Item_Data"]["Jumpshroom1"]["InInventory"] = self.current_data["Item_Data"]["Jumpshroom1"]["InInventory"]
	Global.Player["Item_Data"]["Jumpshroom1"]["Level"] = self.current_data["Item_Data"]["Jumpshroom1"]["Level"]
	Global.Player["Item_Data"]["Jumpshroom1"]["Pos"] = self.current_data["Item_Data"]["Jumpshroom1"]["Pos"]
	Global.Player["Item_Data"]["Jumpshroom2"]["InInventory"] = self.current_data["Item_Data"]["Jumpshroom2"]["InInventory"]
	Global.Player["Item_Data"]["Jumpshroom2"]["Level"] = self.current_data["Item_Data"]["Jumpshroom2"]["Level"]
	Global.Player["Item_Data"]["Jumpshroom2"]["Pos"] = self.current_data["Item_Data"]["Jumpshroom2"]["Pos"]
	
	Global.Player["Item_Data"]["HeartContainer1"]["Purchased"] = self.current_data["Item_Data"]["HeartContainer1"]["Purchased"]
	
	Global.Player["Inventory"]["Jumpshroom"] = self.current_data["Inventory"]["Jumpshroom"]
	Global.Player["Inventory"]["Handle"] = self.current_data["Inventory"]["Handle"]
