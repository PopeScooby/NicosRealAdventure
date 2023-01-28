extends Area2D


func _ready():
	self.visible = false

func _process(delta):
	check_state()
	exec_state()
	
func check_state():
	pass
#	if self.visible and  GlobalDictionaries.current_data["Level_Timer"] <= 0:
#		Global.STATE_LEVEL = "Timeout"
		
func exec_state():

	if Global.STATE_LEVEL == "Spawn_Portal_Exit":
		$AnimationPlayer.play("Portal_Spawn")
		Global.STATE_LEVEL = "Gameplay"
	elif Global.STATE_LEVEL == "Despawn_Portal_Exit":
		$AnimationPlayer.play("Portal_Close")
		Global.STATE_LEVEL = "Gameplay"
#	elif Global.STATE_LEVEL == "Timeout" and Global.STATE_GLOBAL != "GameOver":
#		$Camera2D.current = true
#		$AnimationPlayer.play("Portal_Close")
#		Global.STATE_GLOBAL = "GameOver"


func _on_AnimationPlayer_animation_finished(anim_name):
	
	if anim_name == "Portal_Spawn":
		$AnimationPlayer.play("Portal_Idle")
	elif anim_name == "Portal_Close":
		self.visible = false
		if Global.STATE_LEVEL == "Timeout" and Global.STATE_GLOBAL == "GameOver":
			Global.STATE_PLAYER = "Timeout"
			Global.STATE_LEVEL = "GameOver"
		else:
			if GlobalDictionaries.game["Level_Current"] == 0:
				get_tree().change_scene("res://Scenes/Interface/Menu_GameStart.tscn")
#			elif GlobalDictionaries.game["Level_Current"] == Global.Player["Level_Max"] and GlobalDictionaries.game["Level_Current"] != (Global.Player["Levels"].size() - 1):
#				Global.Player["Level_Max"] += 1
#				Global.Level["Complete"] = true
#		#		Global.Player["Levels"][str(Global.Player["Level_Current"])] = Global.Level
#		#		GlobalDictionaries.players[str(GlobalDictionaries.game["PlayerKey"])] = Global.Player
#				GlobalDictionaries.save_current_data()
#				Global.save_game()
#				get_tree().change_scene("res://Scenes/Interface/Menu_LevelSelect.tscn")

func _on_Portal_body_entered(body):
	if body.name == "Player" and self.visible == true:
		GlobalDictionaries.current_data["Flags"]["On_Exit"] = true


func _on_Portal_body_exited(body):
	if body.name == "Player" and self.visible == true:
		GlobalDictionaries.current_data["Flags"]["On_Exit"] = false
#
