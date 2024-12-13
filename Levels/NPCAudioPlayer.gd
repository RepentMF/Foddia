extends AudioStreamPlayer2D

var audioIndexer = 0
var dialogue
var looped = false

# Called when the node enters the scene tree for the first time.
func _ready():
	dialogue = get_meta("dialogue")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print(get_parent().indexer, ", ", looped)
	if get_parent().interacting:
		if get_parent().indexer != 0:
			if !dialogue[get_parent().indexer - 1] is String:
				if audioIndexer != get_parent().indexer - 1:
					audioIndexer = get_parent().indexer - 1
					stream = dialogue[get_parent().indexer - 1]
					looped = false
				if !is_playing() && !looped:
					play()
				else:
					if get_playback_position() > stream.get_length() - 0.1:
						stop()
						looped = true
				#print(get_playback_position(), ", ", stream.get_length())
	else:
		audioIndexer = 0
		looped = false
		stop()
	
	if %Player.hasMacguffin2:
		dialogue = get_meta("dead")
	if %Player.hasMacguffin:
		dialogue = get_meta("relieved")
	pass
