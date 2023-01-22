extends Area2D

export var move_x = 0.00
export var move_y = 0.00

func _ready():
	pass # Replace with function body.


#func _process(delta):
#	pass


func _on_SetPosition_body_entered(body):
	if body.name.find("Crate") != -1:
		var curr_pos = body.position
		var new_pos = curr_pos + Vector2(move_x, move_y)
		body.position = new_pos

func _on_SetPosition_body_exited(body):
	pass # Replace with function body.
