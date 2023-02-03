extends Button


func _ready():
	pass 

func fill_label(LevelNum):
#
	var Level = Global.Player["Levels"][str(LevelNum)]
	var LevelTxt = "Level #" + str(LevelNum)
	var InfoTxt
	if Level["Coins"].size() == 0:
		InfoTxt = ": [Unexplored]"
	else:
		InfoTxt = ": " + str(Level["Coins_Collected"]) + " of " + str(Level["Coins"].size() + (Level["Chests"].size() * 10)) + " Coins" 
	self.text = LevelTxt + InfoTxt
	if Level.has("Gem_Square"):
		if Level["Gem_Square"] != "":
			if Global.Player["Gem_Square"][Level["Gem_Square"]]:
				$GemCollected.animation = "BW"
			else:
				$GemCollected.animation = Level["Gem_Square"]
	if Level["GotPerfect"]:
		$PerfectCoin.animation = "Shine"
		$PerfectTime.text = Level["Perfect_Time"]
	else:
		$PerfectCoin.animation = "BW"
		$PerfectTime.text = ""

