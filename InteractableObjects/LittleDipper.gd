extends Area2D


func _ready():
	pass

func _on_area_entered(area):
	if area.get_parent().name == "Player":
		%UserPrefsController.user_prefs.achievement_little_dipper = true
		%UserPrefsController.user_prefs.save()
	pass # Replace with function body.
