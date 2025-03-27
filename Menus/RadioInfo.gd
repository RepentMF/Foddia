extends RichTextLabel

var alreadySeenSongs
var artistName = ""
var count = 0
var removeChar
var removeCount = 0
var songData = ""
var songName = ""
var stop = false

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	alreadySeenSongs = ["."]
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if %Radio_bg.visible:
		%Music_bg.visible = true
		if count == 0:
			text = "[center]" + songName + "[/center]"
			visible = true
		elif count == 540:
			text = ""
			visible = false
			%PhoneMover.closePhone = true
			%Music_bg.visible = false
			count = 0
		elif count % 60 == 0:
			if text == "[center]" + songName + "[/center]":
				text = "[center]by[/center]"
			elif text == "[center]by[/center]":
				text = "[center]" + artistName + "[/center]"
			elif text == "[center]" + artistName + "[/center]":
				text = "[center]" + songName + "[/center]"
		count += 1
	pass

func change_songs():
	if songData != %PhoneMover.current_string:
		for array in get_meta("SongData"):
			if array[0] == %PhoneMover.current_string:
				songData = array[0]
				songName = array[1]
				artistName = array[2]
				count = 0
	pass

func isANewSong(nextRecording):
	if !alreadySeenSongs.has(nextRecording):
		alreadySeenSongs.push_front(nextRecording)
		return true
	else:
		return false
