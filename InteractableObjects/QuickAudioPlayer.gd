extends Node2D

var radio
var endingIsPlaying
var startPlaying
var SFX

var temp_volume

# Called when the node enters the scene tree for the first time.
func _ready():
	SFX = get_node("SFX")
	
	if get_parent().name.contains("Ending"):
		endingIsPlaying = true
	else:
		radio = get_parent().get_parent().get_parent()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if endingIsPlaying:
		if !SFX.is_playing():
			SFX.play()
		elif SFX.is_playing():
			if SFX.get_playback_position() > SFX.stream.get_length() - 0.05:
				SFX.stop()
				queue_free()
	if startPlaying && !SFX.is_playing():
		SFX.play()
		radio.get_node("Player").get_node("RadioPlayer").itemIsPlaying = true
	if startPlaying && SFX.get_playback_position() > SFX.stream.get_length() - 0.05:
		radio.get_node("Player").get_node("RadioPlayer").itemIsPlaying = false
		queue_free()
	pass

func _physics_process(delta):
	if !get_parent().name.contains("Ending"):
		if temp_volume != get_tree().root.get_node("Overworld").get_node("SFXVolumeHandler").SFX_volume:
			temp_volume = get_tree().root.get_node("Overworld").get_node("SFXVolumeHandler").SFX_volume
			SFX.volume_db = temp_volume
	else:
		if temp_volume != %SFXVolumeHandler.SFX_volume:
			temp_volume = %SFXVolumeHandler.SFX_volume
			SFX.volume_db = temp_volume
	pass
