extends Area2D



# Called when the node enters the scene tree for the first time.
func _ready():
	self.add_to_group("Gem_Square")
#	if Global.Level.has("Gem_Square"):
#		if Global.Level["Gem_Square"] != "":
#			$Sprite.animation = Global.Level["Gem_Square"]
#		else:
#			$Sprite.animation = "Pink"

func _on_Gem_Square_body_entered(body):
	if body.name == "Adventurer" and self.visible == true:
		register_gem()
		Global.audio_players["RubyCollection"].play()
		queue_free()


func register_gem():
	pass
#	Global.gem_square_count += 1
#	Global.gem_square = false
#

