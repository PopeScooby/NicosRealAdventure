extends CharacterBody2D

var STATE = "Move"

@export var enemy_dict = {
	"Type": "Slug",
	"IsLoop": true,
	"TaskIdx": 0
}

@export var tasks_list = [
	{"Dir_X": 1, "Dir_Y": 0, "Distance_x": 500, "Distance_y": 0, "Speed": 40, "Animation": "MoveNormal"},
	{"Dir_X": -1, "Dir_Y": 0, "Distance_x": 500, "Distance_y": 0, "Speed": 40, "Animation": "MoveNormal"}
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
		velocity.y = gravity
	
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
		Task_Dest_Pos_Y = self.task_start_position.y + (Task["Dir_Y"] * Task["Distance_Y"])
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

