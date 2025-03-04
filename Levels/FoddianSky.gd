extends ParallaxLayer

var user_prefs: UserPreferences

# Called when the node enters the scene tree for the first time.
func _ready():
	user_prefs = UserPreferences.load_or_create()
	if user_prefs.difficulty_dropdown_index == 1:
		visible = true
	pass
