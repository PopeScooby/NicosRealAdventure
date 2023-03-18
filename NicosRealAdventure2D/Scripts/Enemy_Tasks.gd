extends CharacterBody2D

var STATE = "Move"

@export var enemy_dict = {
	"Type": "Slug",
	"IsLoop": true,
	"TaskIdx": 0, 
	"UseGravity": true
}

@export var tasks_list = [
	{"Dir_X": 0, "Dir_Y": -1, "Distance_x": 0, "Distance_y": 600, "Speed": 100, "Animation": "MoveNormal"},
	{"Dir_X": 1, "Dir_Y": 0, "Distance_x": 1100, "Distance_y": 0, "Speed": 150, "Animation": "MoveNormal"},
	{"Dir_X": 0, "Dir_Y": -1, "Distance_x": 0, "Distance_y": 500, "Speed": 100, "Animation": "MoveNormal"},
	{"Dir_X": 0, "Dir_Y": 1, "Distance_x": 0, "Distance_y": 500, "Speed": 200, "Animation": "MoveNormal"},
	{"Dir_X": -1, "Dir_Y": 0, "Distance_x": 1100, "Distance_y": 0, "Speed": 150, "Animation": "MoveNormal"},
	{"Dir_X": 0, "Dir_Y": 1, "Distance_x": 0, "Distance_y": 600, "Speed": 200, "Animation": "MoveNormal"}
]

var task_start_position = Vector2(0, 0)
var task_dest_position = Vector2(0, 0)
var task_prev_position = Vector2(0, 0)
var task_attempts = 0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	task_start_position = self.position
	set_task_dest_position()

func _physics_process(delta):
	
	check_state()
	exec_state()

func check_state():
	pass


func exec_state():
	
	if STATE == "Move":
		exec_state_move()

func exec_state_move():
	var Task = tasks_list[enemy_dict["TaskIdx"]]
	
	if Task["Dir_X"]:
		if self.task_dest_position.x * Task["Dir_X"] < self.position.x * Task["Dir_X"]: 
			set_task_next()
			return
		else:
			velocity.x = Task["Speed"] * Task["Dir_X"]
	else:
		velocity.x = 0
	
	if velocity.x > 0:
		$Sprite2D.flip_h = true
	else:
		$Sprite2D.flip_h = false
	
	if Task["Dir_Y"]:
		if self.task_dest_position.y * Task["Dir_Y"] < self.position.y * Task["Dir_Y"]: 
			set_task_next()
			return
		else:
			velocity.y = Task["Speed"] * Task["Dir_Y"]
	else:
		if enemy_dict["UseGravity"]:
			velocity.y = gravity * 2
		else:
			velocity.y = 0
	
	task_prev_position = self.position
	
	$AnimationPlayer.play(Task["Animation"])
	move_and_slide()
	
	if is_on_floor() and ceil(task_prev_position.x) == ceil(self.position.x) and task_attempts >= 50:
		set_task_next()
		task_attempts = 0
	elif is_on_floor() and ceil(task_prev_position.x) == ceil(self.position.x):
		task_attempts += 1
	else:
		task_attempts = 0


func set_task_dest_position():
	var Task = tasks_list[enemy_dict["TaskIdx"]]
	var Task_Dest_Pos_X 
	var Task_Dest_Pos_Y
	if Task["Dir_X"]:
		Task_Dest_Pos_X = self.task_start_position.x + (Task["Dir_X"] * Task["Distance_x"])
	else:
		Task_Dest_Pos_X = self.position.x
		
	if Task["Dir_Y"]:
		Task_Dest_Pos_Y = self.task_start_position.y + (Task["Dir_Y"] * Task["Distance_y"])
	else:
		Task_Dest_Pos_Y = self.position.y
		
	self.task_dest_position = Vector2(Task_Dest_Pos_X, Task_Dest_Pos_Y)

func set_task_next():
	
	var Task_Count = tasks_list.size() - 1
	
	if enemy_dict["TaskIdx"] == Task_Count:
		if enemy_dict["IsLoop"] == true:
			enemy_dict["TaskIdx"] = 0
		else:
			STATE = "Complete"
	else:
		enemy_dict["TaskIdx"] += 1
	
	task_start_position = self.position
	set_task_dest_position()


func _on_area_2d_hitbox_body_entered(body):
	if body.name == "Player" and GlobalDictionaries.current_data["Hearts_Current"] > 0:
		GlobalDictionaries.current_data["Flags"]["On_Enemy"] = true
		$Timer_Rehit.start()
	elif body.name == "Player" and GlobalDictionaries.current_data["Hearts_Current"] <= 0:
		$Timer_Rehit.stop()

func _on_area_2d_hitbox_body_exited(body):
	$Timer_Rehit.stop()
	GlobalDictionaries.current_data["Flags"]["On_Enemy"] = false

func _on_timer_rehit_timeout():
	if GlobalDictionaries.current_data["Hearts_Current"] > 0:
		GlobalDictionaries.current_data["Flags"]["On_Enemy"] = true
		$Timer_Rehit.start()
	else:
		$Timer_Rehit.stop()

#func _on_timer_rehit_timeout():
#	if GlobalDictionaries.current_data["Hearts_Current"] > 0:
#		GlobalDictionaries.current_data["Flags"]["On_Enemy"] = true
#		$Timer_Damage.start()
#	else:
#		$Timer_Damage.stop()

