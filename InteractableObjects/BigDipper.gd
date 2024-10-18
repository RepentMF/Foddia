extends Area2D

var user_prefs: UserPreferences

func _ready():
	user_prefs = UserPreferences.load_or_create()
	pass

func _on_area_entered(area):
	if area.get_parent().name == "Player":
		user_prefs.achievement_big_dipper = true
	pass # Replace with function body.
