extends Area2D

@export var BounceHeight = -1450

var STATE = "Idle"

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if STATE == "Idle":
		$AnimationPlayer.play("Idle")
	elif STATE == "Bounce":
		$AnimationPlayer.play("Bounce")


func _on_body_entered(body):
	if body.name == "Player" and Global.Player["Animation"] == "Fall":
		GlobalDictionaries.current_data["Interactions"]["Jumpshroom"]["BounceHeight"] = self.BounceHeight
		STATE = "Bounce"
		Global.STATE_PLAYER = "Bounce"
		Global.audio_players["Bounce"].play()

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Bounce":
		STATE = "Idle"
