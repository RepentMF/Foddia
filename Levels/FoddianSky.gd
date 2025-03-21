extends ParallaxLayer

# Called when the node enters the scene tree for the first time.
func _ready():
	if %UserPrefsController.user_prefs.difficulty_dropdown_index == 1:
		visible = true
	pass
