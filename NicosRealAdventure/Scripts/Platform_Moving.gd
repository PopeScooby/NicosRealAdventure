extends Node2D

export var anim_name = ""
export var start_sec = 0
export var is_paused = true

func _ready():
	if anim_name != "":
		$AnimationPlayer.play(anim_name)
		$AnimationPlayer.seek(start_sec, true)
		if is_paused:
			$AnimationPlayer.playback_speed = 0


#func _process(delta):
#
#	check_state()
#	exec_state()
#
