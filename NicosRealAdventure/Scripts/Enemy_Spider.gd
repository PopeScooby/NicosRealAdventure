extends KinematicBody2D

#export var move_speed = [100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100]
export var move_speed = 100
export (NodePath) var patrol_path
var patrol_points
var patrol_index = 0
#var speed_index = 0
var velocity = Vector2.ZERO
#var speed = move_speed[speed_index]

var SpiderName

func _ready():
	SpiderName = self.name
	if patrol_path:
		patrol_points = get_node(patrol_path).curve.get_baked_points()
		self.position = patrol_points[0]
		$AnimationPlayer.play("Spider_1_Move")

		
func _process(delta):
	if !patrol_path:
		return
	var target = patrol_points[patrol_index]
	var dist = position.distance_to(target)
		
	if SpiderName == "Spider1":
		pass
	
	if dist < 1:
		patrol_index = wrapi(patrol_index + 1, 0, patrol_points.size())
		target = patrol_points[patrol_index]
	
	var vecToTarget = (target - self.position)
	var dirToTarget = vecToTarget.normalized()
	var distToTarget = vecToTarget.length()
	
	var willOvershoot = move_speed * delta > distToTarget
	
	if willOvershoot:
		var tempSpeed = distToTarget / delta
		velocity = dirToTarget * tempSpeed
	else:
		velocity = dirToTarget * move_speed
		
	velocity = move_and_slide(velocity)



func _on_Area2D_body_entered(body):

	if body.name == "Player" and GlobalDictionaries.current_data["Hearts_Current"] > 0:
		GlobalDictionaries.current_data["Flags"]["On_Enemy"] = true
		$Timer_Damage.start()
	elif body.name == "Player" and GlobalDictionaries.current_data["Hearts_Current"] <= 0:
		$Timer_Damage.stop()

func _on_Area2D_body_exited(body):
	if body.name == "Player":
		$Timer_Damage.stop()
		GlobalDictionaries.current_data["Flags"]["On_Enemy"] = false


func _on_Timer_Damage_timeout():

	if GlobalDictionaries.current_data["Hearts_Current"] > 0:
		GlobalDictionaries.current_data["Flags"]["On_Enemy"] = true
		$Timer_Damage.start()
	else:
		$Timer_Damage.stop()

