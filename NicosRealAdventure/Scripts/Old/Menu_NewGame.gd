extends Control

var sel_wide = load("res://Textures/Interface/Menu_Select.png")
var sel_sqr = load("res://Textures/Interface/Menu_Select_White.png")
var selector_curr = 0
var selector_locations = {0:{"Position":Vector2(74.751,165.52), "Size":Vector2(358,54)}}


func _ready():
	
	var curr_x = -133
	var curr_y = 271.75
	
	for idx in range(1,57):
		selector_locations[idx] = {"Position":Vector2(curr_x,curr_y),  "Size":Vector2(56.25,56.25)}
		
		if idx == 14 or idx == 28 or idx == 42 or idx == 56:
			curr_x = -133
			curr_y += 56.25
		else:
			curr_x += 56.25
			
	move_selector(false)

func _process(delta):
	
	if Input.is_action_just_pressed("menu_select") and self.visible == true and selector_curr != 0:
		var curr_letter
		var curr_text = $NewNameTxt.text
		if selector_curr == 56:
			if len(curr_text) > 0:
				var idx = len(curr_text) - 1
				curr_text.erase(idx, 1)
				$NewNameTxt.text = curr_text
		elif selector_curr == 42:
			curr_letter = " "
			$NewNameTxt.text = curr_text + curr_letter

		else:
			curr_letter = get_node("Keyboard/Key" + str(selector_curr)).text
			$NewNameTxt.text = curr_text + curr_letter
			

	elif Input.is_action_just_pressed("menu_select") and self.visible == true and selector_curr == 0:
		if $NewNameTxt.text != "":
			_start_game()
	elif Input.is_action_just_pressed("menu_up") and self.visible == true:
		if selector_curr == 0:
			selector_curr = 56
		elif selector_curr >=1 and selector_curr <=14:
			selector_curr = 0
		elif selector_curr >=15 and selector_curr <=56:
			selector_curr -= 14
		self.move_selector()
	elif Input.is_action_just_pressed("menu_down") and self.visible == true:
		if selector_curr == 0:
			selector_curr = 1
		elif selector_curr >=1 and selector_curr <=42:
			selector_curr += 14
		elif selector_curr >=15 and selector_curr <=56:
			selector_curr = 0
		self.move_selector()
	elif Input.is_action_just_pressed("menu_right") and self.visible == true:
		if selector_curr !=0 and selector_curr !=14 and selector_curr !=28 and selector_curr !=42 and selector_curr !=56:
			selector_curr += 1
		elif selector_curr !=0:
			selector_curr -= 13
		self.move_selector()
	elif Input.is_action_just_pressed("menu_left") and self.visible == true:
		if selector_curr !=0 and selector_curr !=1 and selector_curr !=15 and selector_curr !=29 and selector_curr !=43:
			selector_curr -= 1
		elif selector_curr !=0:
			selector_curr += 13
		self.move_selector()
	if selector_curr == 0:
		$Selector.texture = sel_wide
	else:
		$Selector.texture = sel_sqr
	

func move_selector(play_sound: bool = true):
	$Selector.rect_position = selector_locations[selector_curr]["Position"]
	$Selector.rect_size = selector_locations[selector_curr]["Size"]
	if play_sound:
		Global.audio_players["Click"].play()

func _start_game():

	Global.load_new_game($NewNameTxt.text)
	Global.STATE_GLOBAL = "HomeBase"
