extends KinematicBody2D

const UP = Vector2(0,-1)
var STATE = "Move"

export var enemy_dict = {
	"Type": "Slug",
	"Speed": 40,
	"IsLoop": true,
	"MoveIdx": 0,
	"x_Prev" : 0,
	"Attempts": 0
}

export var moves_list = [
	{"Axis":"x", "Distance":500, "Anim_Suffix": "Crawl", "Dir": 1},
	{"Axis":"x", "Distance":-300, "Anim_Suffix": "Crawl", "Dir": -1},
	{"Axis":"x", "Distance":500, "Anim_Suffix": "Crawl", "Dir": 1},
	{"Axis":"x", "Distance":-200, "Anim_Suffix": "Crawl", "Dir": -1}
]

var motion = Vector2(0, 0)
var position_start = Vector2(0, 0)
var gravity = 45

func _ready():
	position_start = self.position

func _process(delta):
	
	check_state()
	exec_state()

func check_state():
	pass

func exec_state():
	
	if STATE == "Move":
		exec_state_move()

func exec_state_move():
	
	var Movement = moves_list[enemy_dict["MoveIdx"]]
	var Axis = Movement["Axis"]
	var Distance = Movement["Distance"] * Movement["Dir"]
	var Destination = position_start
	var curr_pos = self.position
	
	if Axis == "x":
		Destination.x += Distance
		
		if Distance > 0:
			if self.position.x >= Destination.x:
				advance_movement(Destination)
				return
		else:
			if self.position.x <= Destination.x:
				advance_movement(Destination)
				return
		
		if is_on_floor():
			motion.x = enemy_dict["Speed"] * Movement["Dir"]
			motion.y = gravity
		else:
			motion.x = 0
			motion.y = 500

		var AnimName = enemy_dict["Type"] + "_" + str(Movement["Dir"]) + "_" + Movement["Anim_Suffix"]
		$AnimationPlayer.play(AnimName)
		
	
	enemy_dict["x_Prev"] = self.position.x
	
	move_and_slide(motion, UP)
	
	var new_pos = self.position
	var SlugName = self.name
	if is_on_floor() and ceil(enemy_dict["x_Prev"]) == ceil(self.position.x) and enemy_dict["Attempts"] >= 100:
		advance_movement(Destination)
		position_start = self.position
		enemy_dict["Attempts"] = 0
		return
	elif is_on_floor() and ceil(enemy_dict["x_Prev"]) == ceil(self.position.x):
		enemy_dict["Attempts"] += 1
	else:
		enemy_dict["Attempts"] = 0

func advance_movement(Destination):
	
	var Move_Count = moves_list.size() - 1
	var SlugName = self.name
	
	if enemy_dict["MoveIdx"] == Move_Count:
		if enemy_dict["IsLoop"] == true:
			enemy_dict["MoveIdx"] = 0
		else:
			STATE = "Complete"
	else:
		enemy_dict["MoveIdx"] += 1
	
	var pos_curr = self.position
	position_start = Destination


func _on_Area2D_body_entered(body):

	if body.name == "Adventurer" and GlobalDictionaries.current_data["Hearts_Current"] > 0:
		GlobalDictionaries.current_data["Flags"]["On_Enemy"] = true
		$Timer_Damage.start()
	elif body.name == "Adventurer" and GlobalDictionaries.current_data["Hearts_Current"] <= 0:
		$Timer_Damage.stop()

func _on_Area2D_body_exited(body):
	$Timer_Damage.stop()
	GlobalDictionaries.current_data["Flags"]["On_Enemy"] = false


func _on_Timer_Damage_timeout():

	if GlobalDictionaries.current_data["Hearts_Current"] > 0:
		GlobalDictionaries.current_data["Flags"]["On_Enemy"] = true
		$Timer_Damage.start()
	else:
		$Timer_Damage.stop()
