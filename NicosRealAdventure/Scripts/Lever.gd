extends Node2D

export var is_active = false

export (NodePath) var mover_path
export var activate_anim_name = ""
export var deactivate_anim_name = ""

export (NodePath) var mover_path2
export var activate_anim_name_2 = ""
export var deactivate_anim_name_2 = ""

export var change_sprite = false
export (NodePath) var sprite_path
export (Texture) var activate_texture
export (Texture) var deactivate_texture

var lever_name

func _ready():
	
	lever_name = self.name
	
	if is_active == false:
		$AnimationPlayer.play("Not_Active")
	else:
		$AnimationPlayer.play("Is_Active")


func _process(delta):
	if Input.is_action_just_pressed("action_interact") and GlobalDictionaries.current_data["Flags"]["Can_PullLever"] == true and GlobalDictionaries.current_data["Game_Info"]["Object_Interact"] == self.name and self.visible:
		
		if is_active == false:
			$AnimationPlayer.play("Activate")
		else:
			$AnimationPlayer.play("Deactivate")

func _on_Area2D_body_entered(body):
	if body.name == "Adventurer" and self.visible == true:
		GlobalDictionaries.current_data["Game_Info"]["Object_Interact"] = self.name
		GlobalDictionaries.current_data["Flags"]["Can_PullLever"] = true

func _on_Area2D_body_exited(body):
	if body.name == "Adventurer" and self.visible == true:
		GlobalDictionaries.current_data["Flags"]["Can_PullLever"] = false

#		var mover = get_node(mover_path + "/AnimationPlayer")
#		mover.play("Activate")


func _on_AnimationPlayer_animation_finished(anim_name):
	
	var mover = get_node(mover_path)
	var anim_player = mover.get_node("AnimationPlayer")
	var anim_player_anim = anim_player.current_animation
	var anim_pos = anim_player.current_animation_position
	var anim_len = anim_player.current_animation_length
	var new_anim_pos = anim_len - anim_pos
			
	if anim_name == "Activate":
		is_active = true
		$AnimationPlayer.play("Is_Active")
		if activate_anim_name == "STOP":
			anim_player.playback_speed = 0
		else:
			anim_player.playback_speed = 1
			anim_player.play(activate_anim_name)
			if new_anim_pos != 0:
				anim_player.seek(new_anim_pos, true)
	elif anim_name == "Deactivate":
		is_active = false
		$AnimationPlayer.play("Not_Active")
		if deactivate_anim_name == "STOP":
			anim_player.playback_speed = 0
		else:
			anim_player.playback_speed = 1
			anim_player.play(deactivate_anim_name)
			if new_anim_pos != 0:
				anim_player.seek(new_anim_pos, true)
		
	if activate_anim_name_2 != "":
		mover = get_node(mover_path2)
		anim_player = mover.get_node("AnimationPlayer")
		anim_player_anim = anim_player.current_animation
		anim_pos = anim_player.current_animation_position
		anim_len = anim_player.current_animation_length
		new_anim_pos = anim_len - anim_pos

		if anim_name == "Activate":
			is_active = true
			$AnimationPlayer.play("Is_Active")
			if activate_anim_name_2 == "STOP":
				anim_player.playback_speed = 0
			else:
				anim_player.playback_speed = 1
				anim_player.play(activate_anim_name_2)
				if new_anim_pos != 0:
					anim_player.seek(new_anim_pos, true)
		elif anim_name == "Deactivate":
			is_active = false
			$AnimationPlayer.play("Not_Active")
			if deactivate_anim_name_2 == "STOP":
				anim_player.playback_speed = 0
			else:
				anim_player.playback_speed = 1
				anim_player.play(deactivate_anim_name_2)
				if new_anim_pos != 0:
					anim_player.seek(new_anim_pos, true)

	if change_sprite:
		var sprite = get_node(sprite_path)
		if sprite != null:
			if anim_name == "Activate":
				sprite.texture = activate_texture
			elif anim_name == "Deactivate":
				sprite.texture = deactivate_texture
