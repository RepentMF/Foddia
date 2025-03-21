extends Node

var OST_volume

func _ready():
	if %UserPrefsController.user_prefs.music_audio_level > 0:
		OST_volume = (0.48 * %UserPrefsController.user_prefs.music_audio_level) - 24
	elif %UserPrefsController.user_prefs.music_audio_level == 0:
		OST_volume = -80
	pass

func _physics_process(_delta):
	if %UserPrefsController.user_prefs.music_audio_level > 0:
		OST_volume = (0.48 * %UserPrefsController.user_prefs.music_audio_level) - 24
	elif %UserPrefsController.user_prefs.music_audio_level == 0:
		OST_volume = -80
	pass
