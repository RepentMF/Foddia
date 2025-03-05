extends Node

var user_prefs: UserPreferences
var OST_volume

func _ready():
	user_prefs = UserPreferences.load_or_create()
	if user_prefs.music_audio_level > 0:
		OST_volume = (0.48 * user_prefs.music_audio_level) - 24
	elif user_prefs.music_audio_level == 0:
		OST_volume = -80
	pass

func _physics_process(_delta):
	if user_prefs.music_audio_level > 0:
		OST_volume = (0.48 * user_prefs.music_audio_level) - 24
	elif user_prefs.music_audio_level == 0:
		OST_volume = -80
	pass
