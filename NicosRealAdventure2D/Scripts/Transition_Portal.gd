extends Area2D

@export var PotalType = "Enter"

func _ready():
	pass 


func _process(delta):
	if Global.STATE_LEVEL == "Portal_Enter_Open" and PotalType == "Enter":
		$AnimationPlayer.play("Portal_Enter_Open")
		Global.STATE_LEVEL = "Portal_Enter_Opening"
	elif Global.STATE_LEVEL == "Portal_Enter_Close" and PotalType == "Enter":
		$AnimationPlayer.play("Portal_Enter_Close")
		Global.STATE_LEVEL = "Portal_Enter_Closing"
	if Global.STATE_LEVEL == "Portal_Exit_Open" and PotalType == "Exit":
		$AnimationPlayer.play("Portal_Exit_Open")
		Global.STATE_LEVEL = "Portal_Exit_Opening"
	elif Global.STATE_LEVEL == "Portal_Exit_Close" and PotalType == "Exit":
		$AnimationPlayer.play("Portal_Exit_Close")
		Global.STATE_LEVEL = "Portal_Exit_Closing"


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Portal_Enter_Open":
		Global.STATE_LEVEL = "Player_Spawn"
		$AnimationPlayer.play("Portal_Enter_Idle")
	elif anim_name == "Portal_Enter_Close":
		Global.STATE_LEVEL = "Portal_Exit_Open"
	elif anim_name == "Portal_Exit_Open":
		Global.STATE_LEVEL = "Gameplay"
		$AnimationPlayer.play("Portal_Exit_Idle")
