extends Area2D

export var BounceHeight = -2500

var STATE = "Idle"


func _ready():
	pass # Replace with function body.

func _process(delta):
	if STATE == "Idle":
		$AnimationPlayer.play("Idle")
	elif STATE == "Bounce":
		$AnimationPlayer.play("Bounce")

func _on_Jumpshroom_body_entered(body):
	
	if body.name == "Adventurer" and Global.Player["Animation"] == "Fall":
		GlobalDictionaries.current_data["Interactions"]["Jumpshroom"]["BounceHeight"] = self.BounceHeight
		STATE = "Bounce"
		Global.STATE_PLAYER = "Bounce"
		Global.audio_players["Bounce"].play()
#
#func _on_Jumpshroom_body_exited(body):
#	if body.name == "Adventurer":
##		Global.Player["Interactions"]["Jumpshroom"]["BounceHeight"] = 0

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Bounce":
		STATE = "Idle"


