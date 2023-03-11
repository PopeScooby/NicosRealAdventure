extends Area2D

@export var flow_dir = 1
@export var flow_speed = 150

var my_name

func _ready():
	my_name = self.name


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	
	var body_name = body.name
	
	if body_name == "Player":
		Global.STATE_PLAYER = "InWater"
	elif body_name.left(5) == "Crate":
		body.water_body = my_name
		body.in_water = true
		body.flow_dir = flow_dir
		body.flow_speed = flow_speed

func _on_body_exited(body):
	
	var body_name = body.name
	
	if body_name.left(5) == "Crate" and body.water_body == my_name:
		body.in_water = false
