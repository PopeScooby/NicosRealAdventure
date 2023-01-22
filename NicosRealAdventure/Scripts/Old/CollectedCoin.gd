extends Control

var target_pos = null
var duration = .3
onready var tween = get_node("Tween")

func _ready():
	var coin_ui: TextureRect = get_parent().get_parent().get_node("GameplayInterface/Coin/CoinImage")
	self.rect_size = coin_ui.rect_size
	
	# Target the coin total UI by default
	if target_pos == null:
		self.target_pos = coin_ui.rect_global_position
	

func set_target_pos(new_target: Vector2):
	self.target_pos = new_target


func set_duration(duration: float):
	self.duration = duration
	
	
func animate():
	self.tween.interpolate_property(self, "rect_global_position", self.rect_global_position, self.target_pos, self.duration, Tween.TRANS_LINEAR, Tween.EASE_IN)
	self.tween.start()
	self.tween.interpolate_callback(self, self.duration, "queue_free")
	
