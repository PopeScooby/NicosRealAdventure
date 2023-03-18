extends CharacterBody2D


@export var patrol_path:Node
@export var move_speed_list = [100, 250, 100, 400, 250, 400]
var speed_index = 0
var move_speed = move_speed_list[speed_index]


#@export var move_speed = 100

var patrol_points
var patrol_index = 0

var SpiderName

func _ready():
	SpiderName = self.name
	if patrol_path:
		patrol_points = patrol_path.curve.get_baked_points()
		self.position = patrol_points[0]
		$AnimationPlayer.play("MoveNormal")

func _physics_process(delta):
	if !patrol_path:
		return
	var target = patrol_points[patrol_index]
	var dist = position.distance_to(target)
	
	if dist < 1:
		patrol_index = wrapi(patrol_index + 1, 0, patrol_points.size())
		speed_index = wrapi(speed_index + 1, 0, move_speed_list.size())
		target = patrol_points[patrol_index]
		move_speed = move_speed_list[speed_index]
	
	var vecToTarget = (target - self.position)
	var dirToTarget = vecToTarget.normalized()
	var distToTarget = vecToTarget.length()
	
	var willOvershoot = move_speed * delta > distToTarget
	
	if willOvershoot:
		var tempSpeed = distToTarget / delta
		velocity = dirToTarget * tempSpeed
	else:
		velocity = dirToTarget * move_speed
		
	move_and_slide()


func _on_area_2d_hitbox_body_entered(body):
	if body.name == "Player" and GlobalDictionaries.current_data["Hearts_Current"] > 0:
		GlobalDictionaries.current_data["Flags"]["On_Enemy"] = true
		$Timer_Rehit.start()
	elif body.name == "Player" and GlobalDictionaries.current_data["Hearts_Current"] <= 0:
		$Timer_Rehit.stop()


func _on_area_2d_hitbox_body_exited(body):
	if body.name == "Player":
		$Timer_Rehit.stop()
		GlobalDictionaries.current_data["Flags"]["On_Enemy"] = false


func _on_timer_rehit_timeout():
	if GlobalDictionaries.current_data["Hearts_Current"] > 0:
		GlobalDictionaries.current_data["Flags"]["On_Enemy"] = true
		$Timer_Rehit.start()
	else:
		$Timer_Rehit.stop()
