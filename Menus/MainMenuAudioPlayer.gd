extends Node2D

var carEngine
var carEngine2
var carEngineStart
var startGame
var temp_volume

var engineStart = false

# Called when the node enters the scene tree for the first time.
func _ready():
	carEngine = get_node("CarEngine")
	carEngine2 = get_node("CarEngine2")
	carEngineStart = get_node("CarEngineStart")
	startGame = get_node("StartGame")
	
	if %UserPrefsController.user_prefs.screenshake_bool_check && !get_parent().name.contains("Ending"):
		carEngine2.play()
		engineStart = true
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if temp_volume != %SFXVolumeHandler.SFX_volume:
		temp_volume = %SFXVolumeHandler.SFX_volume
		change_all_volumes()
	if !get_parent().name.contains("Ending"):
		if %StartGame.volume_db != %OSTVolumeHandler.OST_volume:
			if %StartGame.volume_db > 0:
				startGame.volume_db = temp_volume - 10
			else:
				startGame.volume_db = temp_volume - 15
	if %UserPrefsController.user_prefs.screenshake_bool_check || get_parent().name.contains("Ending"):
		if !engineStart:
			carEngineStart.play()
			engineStart = true
		if (carEngine.get_playback_position() > carEngine.stream.get_length() - 0.08 || carEngineStart.get_playback_position() > 1.48) && !carEngine2.is_playing():
			carEngine2.play()
		if carEngine2.get_playback_position() > carEngine2.stream.get_length() - 0.08  && !carEngine.is_playing():
			carEngine.play()
	else:
		carEngine.stop()
		carEngine2.stop()
		carEngineStart.stop()
		engineStart = false
	pass

func change_all_volumes():
	if carEngine.volume_db > 0:
		carEngine.volume_db = temp_volume - 20
		carEngine2.volume_db = temp_volume - 20
		carEngineStart.volume_db = temp_volume - 20
	else:
		carEngine.volume_db = temp_volume - 10
		carEngine2.volume_db = temp_volume - 10
		carEngineStart.volume_db = temp_volume - 10
	pass
