extends Area2D

var user_prefs: UserPreferences

# Called when the node enters the scene tree for the first time.
func _ready():
	user_prefs = UserPreferences.load_or_create()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	get_node("RopeReleased").volume_db = change_volume(user_prefs.sfx_audio_level)
	get_node("RopeSwung").volume_db = change_volume(user_prefs.sfx_audio_level)
	pass

func _on_creak_area_entered(area):
	if area.get_parent() != null && area.name.contains("Hands"):
		if area.get_parent().hasReleasedRope:
			get_node("RopeReleased").play(0)
		elif area.get_parent().swingRope != null:
			if name.contains("Left"):
				get_node("RopeSwung").pitch_scale = 1.1
			elif name.contains("Right"):
				get_node("RopeSwung").pitch_scale = 1.2
			get_node("RopeSwung").play(0)
	pass # Replace with function body.

func change_volume(volume):
	var temp_volume = 0
	if volume >= 51:
		temp_volume = (0.48 * volume) - 24
	elif volume < 51:
		temp_volume = (1.6 * volume) - 80
	return temp_volume
	pass
