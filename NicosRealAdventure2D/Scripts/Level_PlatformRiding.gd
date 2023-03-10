extends Node2D

@export var LEVER_STATE = "Neutral"
@export var LEVER_STATE_prev = "Inactive"

@export var Platform_Anim_StartSec = 0.00

@export var Platform_Anim_Active = ""
@export var Platform_Anim_Inactive = ""

var is_loaded = false

func _ready():
	if LEVER_STATE == "Active":
		$Platform/Lever/AnimationPlayer.play("Is_Active")
		$AnimationPlayer.speed_scale = 1
		$AnimationPlayer.play(Platform_Anim_Active)
		$AnimationPlayer.seek(Platform_Anim_StartSec, true)
	elif LEVER_STATE == "Neutral":
		$Platform/Lever/AnimationPlayer.play("Is_Neutral")
		$AnimationPlayer.speed_scale = 0
		if LEVER_STATE_prev == "Active":
			$AnimationPlayer.play(Platform_Anim_Active)
		elif LEVER_STATE_prev == "Inactive":
			$AnimationPlayer.play(Platform_Anim_Inactive)
		$AnimationPlayer.seek(Platform_Anim_StartSec, true)
	elif LEVER_STATE == "Inactive":
		$Platform/Lever/AnimationPlayer.play("Not_Active")
		$AnimationPlayer.speed_scale = 1
		$AnimationPlayer.play(Platform_Anim_Inactive)
		$AnimationPlayer.seek(Platform_Anim_StartSec, true)
	
func _process(delta):

	if Input.is_action_just_pressed("action_interact") and GlobalDictionaries.current_data["Flags"]["Can_PullLever"] == true and GlobalDictionaries.current_data["Game_Info"]["Object_Interact"] == self.name:
		if LEVER_STATE == "Inactive" or LEVER_STATE == "Active":
			LEVER_STATE_prev = LEVER_STATE
			LEVER_STATE = "Neutral"
			$Platform/Lever/AnimationPlayer.play("Is_Neutral")
		elif LEVER_STATE == "Neutral":
			if LEVER_STATE_prev == "Active":
				LEVER_STATE_prev = LEVER_STATE
				LEVER_STATE = "Inactive"
				$Platform/Lever/AnimationPlayer.play("Not_Active")
			elif LEVER_STATE_prev == "Inactive":
				LEVER_STATE_prev = LEVER_STATE
				LEVER_STATE = "Active"
				$Platform/Lever/AnimationPlayer.play("Is_Active")



func _on_area_2d_body_entered(body):
	if body.name == "Player" and self.visible == true:
		GlobalDictionaries.current_data["Game_Info"]["Object_Interact"] = self.name
		GlobalDictionaries.current_data["Flags"]["Can_PullLever"] = true


func _on_area_2d_body_exited(body):
	if body.name == "Player" and self.visible == true:
		GlobalDictionaries.current_data["Flags"]["Can_PullLever"] = false


func _on_lever_animation_player_animation_finished(anim_name):
	
	if is_loaded:
		var anim_pos = $AnimationPlayer.current_animation_position
		var anim_len = $AnimationPlayer.current_animation_length
		var new_anim_pos = anim_len - anim_pos
		
		if anim_name == "Is_Active": 
			$AnimationPlayer.play(Platform_Anim_Active)
			$AnimationPlayer.speed_scale = 1
			if new_anim_pos != 0:
				$AnimationPlayer.seek(new_anim_pos, true)
		elif anim_name == "Not_Active":
			$AnimationPlayer.play(Platform_Anim_Inactive)
			$AnimationPlayer.speed_scale = 1
			if new_anim_pos != 0:
				$AnimationPlayer.seek(new_anim_pos, true)
		elif anim_name == "Is_Neutral":
			$AnimationPlayer.speed_scale = 0
	else:
		is_loaded = true



func _on_platform_animation_player_animation_finished(anim_name):
	if anim_name == Platform_Anim_Active:
		LEVER_STATE_prev = LEVER_STATE
		LEVER_STATE = "Neutral"
		$Platform/Lever/AnimationPlayer.play("Is_Neutral")
	elif anim_name == Platform_Anim_Inactive:
		LEVER_STATE_prev = LEVER_STATE
		LEVER_STATE = "Neutral"
		$Platform/Lever/AnimationPlayer.play("Is_Neutral")

