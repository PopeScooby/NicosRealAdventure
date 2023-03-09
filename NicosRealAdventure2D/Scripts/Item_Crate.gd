extends CharacterBody2D

var in_water = false
var flow_dir = 1
var flow_speed = 150
var on_adventurer = false

func _physics_process(delta):
	
	if not is_on_floor():
		velocity.y += GlobalDictionaries.current_data["Game_Info"]["Gravity"] * delta

	if GlobalDictionaries.current_data["Flags"]["Can_Push"] == true and Input.is_action_pressed("action_interact"):
		if Input.get_axis("move_left", "move_right") and GlobalDictionaries.current_data["Game_Info"]["Object_Interact"] == self.name:
			velocity.x = Input.get_axis("move_left", "move_right") * GlobalDictionaries.current_data["Game_Info"]["SpeedMax"]
		else:
			velocity.x = move_toward(velocity.x, 0, GlobalDictionaries.current_data["Game_Info"]["SpeedMax"])

	else:
		velocity.x = 0


	move_and_slide()

#	motion.y += gravity
#
#	var friction = false
##
#	if in_water == false:
#		<Code is writen>
#
#	else:
#		if flow_dir == 1:
#			motion.x = flow_speed
##			motion.y = 80
#		elif flow_dir == -1:
#			motion.x = -flow_speed
##			motion.y = 80


func _on_area_2d_interact_body_entered(body):
	if body.name == "Player":
		if body.position.x > self.position.x:
			GlobalDictionaries.current_data["Flags"]["Crate_R"] = true
		else:
			GlobalDictionaries.current_data["Flags"]["Crate_R"] = false
		GlobalDictionaries.current_data["Game_Info"]["Object_Interact"] = self.name
		GlobalDictionaries.current_data["Flags"]["Can_Push"] = true


func _on_area_2d_interact_body_exited(body):
	if body.name == "Player":
		GlobalDictionaries.current_data["Flags"]["Can_Push"] = false
