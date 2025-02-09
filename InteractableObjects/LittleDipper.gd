extends Area2D

var user_prefs: UserPreferences

func _ready():
	user_prefs = UserPreferences.load_or_create()
	pass

func _on_area_entered(area):
	if area.get_parent().name == "Player":
		user_prefs.achievement_little_dipper = true
		user_prefs.save()
	pass # Replace with function body.
