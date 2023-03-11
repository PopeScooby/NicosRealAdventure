extends Area2D


func _on_body_entered(body):
	if body.name == "Player" and GlobalDictionaries.current_data["Hearts_Current"] > 0:
		GlobalDictionaries.current_data["Flags"]["On_Spikes"] = true
		$Timer_Damage.start()
	elif body.name == "Player" and GlobalDictionaries.current_data["Hearts_Current"] <= 0:
		$Timer_Damage.stop()


func _on_body_exited(body):
	$Timer_Damage.stop()
	GlobalDictionaries.current_data["Flags"]["On_Spikes"] = false


func _on_timer_damage_timeout():
	if GlobalDictionaries.current_data["Hearts_Current"] > 0:
		GlobalDictionaries.current_data["Flags"]["On_Spikes"] = true
		$Timer_Damage.start()
	else:
		$Timer_Damage.stop()
