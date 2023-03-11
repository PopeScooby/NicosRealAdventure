extends Area2D

@export var move_x = 0.00
@export var move_y = 0.00
@export var body_list = ["Crate"]


func _on_body_entered(body):
	if body.name.find("Crate") != -1:
		var curr_pos = body.position
		var new_pos = curr_pos + Vector2(move_x, move_y)
		body.position = new_pos
