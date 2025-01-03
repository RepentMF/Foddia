extends Node2D

var user_prefs: UserPreferences

var carEngine
var carEngine2
var carEngineStart

var engineStart = false

# Called when the node enters the scene tree for the first time.
func _ready():
	user_prefs = UserPreferences.load_or_create()
	carEngine = get_node("CarEngine")
	carEngine2 = get_node("CarEngine2")
	carEngineStart = get_node("CarEngineStart")
	if user_prefs.screenshake_bool_check:
		carEngine2.play()
		engineStart = true
	else:
		engineStart = false
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	change_all_volumes()
	if user_prefs.screenshake_bool_check:
		if !engineStart:
			carEngineStart.play()
			engineStart = true
		if (carEngine.get_playback_position() > 4.8 || carEngineStart.get_playback_position() > 1.48) && !carEngine2.is_playing():
			carEngine2.play()
		if carEngine2.get_playback_position() > 4.8  && !carEngine.is_playing():
			carEngine.play()
	else:
		carEngine.stop()
		carEngine2.stop()
		carEngineStart.stop()
		engineStart = false
	pass

func change_volume(volume):
	var temp_volume
	if volume >= 51:
		temp_volume = (0.48 * volume) - 24
	elif user_prefs.sfx_audio_level < 51:
		temp_volume = (1.6 * volume) - 80
	return temp_volume
	pass

func change_all_volumes():
	if carEngine.volume_db > 0:
		carEngine.volume_db = change_volume(user_prefs.sfx_audio_level) - 12
		carEngine2.volume_db = change_volume(user_prefs.sfx_audio_level) - 12
		carEngineStart.volume_db = change_volume(user_prefs.sfx_audio_level) - 12
	else:
		carEngine.volume_db = change_volume(user_prefs.sfx_audio_level) - 2
		carEngine2.volume_db = change_volume(user_prefs.sfx_audio_level) - 2
		carEngineStart.volume_db = change_volume(user_prefs.sfx_audio_level) - 2
	pass
