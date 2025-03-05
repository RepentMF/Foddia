extends VideoStreamPlayer

var user_prefs: UserPreferences

var video
var length
var capture

# Called when the node enters the scene tree for the first time.
func _ready():
	user_prefs = UserPreferences.load_or_create()
	change_colors()
	if get_parent().get_parent().get_meta("TutorialComponents")[1] != 0:
		video = get_parent().get_parent().get_meta("TutorialComponents")[0]
		length = get_parent().get_parent().get_meta("TutorialComponents")[1]
		capture = get_parent().get_parent().get_meta("TutorialComponents")[2]
		stream = video
	%TutorialCapture.texture = capture
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if get_parent().get_parent().get_meta("TutorialComponents")[1] != 0:
		if get_parent().get_parent().visible:
			if !is_playing() && %TutorialCapture.visible:
				play()
			if is_playing() && stream_position > 0.1:
				%TutorialCapture.visible = false
			if is_playing() && stream_position > length - 0.1:
				stop()
				%TutorialCapture.visible = true
	pass

func change_colors():
	if user_prefs.title_color_index == 0:
		modulate = Color(1, .776, .639)
		%Billboard.modulate = Color(1, .776, .639)
		%TutorialCapture.modulate = Color(1, .776, .639)
	elif user_prefs.title_color_index == 2:
		modulate = Color(1, .990, .557)
		%Billboard.modulate = Color(1, .990, .557)
		%TutorialCapture.modulate = Color(1, .990, .557)
	elif user_prefs.title_color_index == 3:
		modulate = Color(.643, .769, 1)
		%Billboard.modulate = Color(.643, .769, 1)
		%TutorialCapture.modulate = Color(.643, .769, 1)
	elif user_prefs.title_color_index == 4:
		modulate = Color(.784, 1, .808)
		%Billboard.modulate = Color(.784, 1, .808)
		%TutorialCapture.modulate = Color(.784, 1, .808)
	elif user_prefs.title_color_index == 5:
		modulate = Color(.901, .651, .780)
		%Billboard.modulate = Color(.901, .651, .780)
		%TutorialCapture.modulate = Color(.901, .651, .780)
	pass

func _on_finished():
	%TutorialCapture.visible = true
	pass # Replace with function body.
