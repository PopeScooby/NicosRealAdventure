extends Control

var selector_curr = 1
var selector_locations = {1:532, 2:592, 3:652}

func _ready():
	Global.STATE_GLOBAL = "Gamestart"
	Global.is_debug = false
	get_node("Menu_NewGame").visible = false

func _physics_process(delta):
	if Input.is_action_just_pressed("menu_down") and selector_curr != 0:
		if selector_curr != 3:
			selector_curr += 1
			_move_selector()
	
	elif Input.is_action_just_pressed("menu_up") and selector_curr != 0:
		if selector_curr != 1:
			selector_curr -= 1
			_move_selector()
	
	elif Input.is_action_just_pressed("menu_select"):
		if selector_curr == 1:
			_new_game()
		elif selector_curr == 2:
			_continue()
		elif selector_curr == 3:
			get_tree().quit()

	elif Input.is_action_just_pressed("menu_back"):
		if selector_curr == 0:
			selector_curr = 1
			get_node("Selector").visible = true
			get_node("Menu_NewGame").visible = false

func _move_selector(play_sound: bool = true):
	get_node("Selector").rect_position.y = selector_locations[selector_curr]
	if play_sound:
		Global.audio_players["Click"].play()
		
func _new_game():
	selector_curr = 0
	get_node("Selector").visible = false
	get_node("Menu_NewGame").visible = true


func _continue():
	get_tree().change_scene("res://Scenes/Interface/Menu_PlayerSelect.tscn")
	pass


