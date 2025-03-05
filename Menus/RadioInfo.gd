extends RichTextLabel

var blankCount = 0
var blankString = ""
var count = 0
var newSong = false
var removeChar
var removeCount = 0
var songData = ""
var stop = false
var tempString

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if %RadioMover.move:
		count += 1
	if count % 6 == 0 && count != 0 && !stop:
		visible_characters += 1
		if removeChar:
			blankCount += 1
			tempString = tempString.right(tempString.length() - blankCount)
			blankString = " " + blankString
			tempString = blankString + tempString
			text = tempString
			for char in text:
				if char == " ":
					removeCount += 1
					if removeCount == text.length():
						stop = true
						%RadioMover.position = Vector2(-8, -408)
			removeCount = 0
	if count >= 95:
		removeChar = true
	pass

func change_songs(songString):
	if text != songString:
		text = songString
		tempString = songString
		songData = songString
		newSong = true
	pass
