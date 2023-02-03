extends KinematicBody2D

const UP = Vector2(0,-1)

var gravity = 80
var acceleration = 200

var motion = Vector2()

var in_water = false
var flow_dir = 1
var flow_speed = 150
var on_adventurer = false

func _ready():
	pass 


func _process(delta):
	
	if self.on_adventurer:
		motion.y = -5
		motion.x = 0
	else:
		motion.y += gravity

		var friction = false
	#
		if in_water == false:
			if GlobalDictionaries.current_data["Flags"]["Can_Push"] == true and Input.is_action_pressed("action_interact"):

				if Input.is_action_pressed("move_right") and GlobalDictionaries.current_data["Game_Info"]["Object_Interact"] == self.name:
					motion.x = min(motion.x+acceleration, GlobalDictionaries.current_data["Game_Info"]["SpeedMax"])
				elif Input.is_action_pressed("move_left") and GlobalDictionaries.current_data["Game_Info"]["Object_Interact"] == self.name:
					motion.x = max(motion.x-acceleration, -GlobalDictionaries.current_data["Game_Info"]["SpeedMax"])
				else:
					friction = true

				if is_on_floor():
					if friction == true:
						motion.x = lerp(motion.x, 0, 0.2)

			else:
				motion.x = 0

		else:
			if flow_dir == 1:
				motion.x = flow_speed
	#			motion.y = 80
			elif flow_dir == -1:
				motion.x = -flow_speed
	#			motion.y = 80

	#	if on_elevator == true:
	#		motion.y = -800
##
	motion = move_and_slide(motion, UP)
#

func _on_InteractArea2D_body_entered(body):
	if body.name == "Player":
		if body.position.x > self.position.x:
			GlobalDictionaries.current_data["Flags"]["Crate_R"] = true
		else:
			GlobalDictionaries.current_data["Flags"]["Crate_R"] = false
		GlobalDictionaries.current_data["Game_Info"]["Object_Interact"] = self.name
		GlobalDictionaries.current_data["Flags"]["Can_Push"] = true


func _on_InteractArea2D_body_exited(body):
	if body.name == "Player":
		GlobalDictionaries.current_data["Flags"]["Can_Push"] = false


func _on_OnCrateArea2D_body_entered(body):
	if body.name == "Player":
		GlobalDictionaries.current_data["Flags"]["On_Crate"] = true
#		GlobalDictionaries.current_data["Game_Info"]["Object_Interact"] = self.name

func _on_OnCrateArea2D_body_exited(body):
	if body.name == "Player":
		GlobalDictionaries.current_data["Flags"]["On_Crate"] = false


func _on_OnAdventurer2D_body_entered(body):
	var body_name = body.name
	if body.name == "Player":
		self.on_adventurer = true

func _on_OnAdventurer2D_body_exited(body):
	if body.name == "Player":
		self.on_adventurer = false
