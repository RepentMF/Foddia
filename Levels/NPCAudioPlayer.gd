extends AudioStreamPlayer2D

var user_prefs: UserPreferences

var audioIndexer = 0
var dialogue
var looped = false
var temp_volume

# Called when the node enters the scene tree for the first time.
func _ready():
	user_prefs = UserPreferences.load_or_create()
	dialogue = get_meta("dialogue")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if user_prefs.voice_acting_bool_check:
		if temp_volume != %OSTVolumeHandler.OST_volume:
			temp_volume = %OSTVolumeHandler.OST_volume
		if get_parent().interacting:
			if get_parent().indexer != 0:
				if !dialogue[get_parent().indexer - 1] is String:
					if audioIndexer != get_parent().indexer - 1:
						audioIndexer = get_parent().indexer - 1
						stream = dialogue[audioIndexer]
						volume_db = temp_volume
						looped = false
					if !is_playing() && !looped:
						play()
					else:
						if get_playback_position() > stream.get_length() - 0.1:
							stop()
							looped = true
		else:
			audioIndexer = -1
			looped = false
			stop()
		
		if %Player.hasMacguffin2:
			dialogue = get_meta("dead")
		if %Player.hasMacguffin:
			dialogue = get_meta("relieved")
	pass
