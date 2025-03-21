extends RichTextLabel

var colorCount = 0
var count = 1
var timer

# Called when the node enters the scene tree for the first time.
func _ready():
	timer = %TimerDisplay
	pass # Replace with function body.

func _process(_delta):
	if text == "":
		var timerM = timer.m
		var timerS = timer.s
		if timerM < 10:
			timerM = "0" + str(timer.m)
		if timerS < 10:
			timerS = "0" + str(timer.s)
		text = str(timer.h) + ":" + str(timerM) + ":" + str(timerS) + "." + str(timer.ms) + "  -  completion  time  this  hike  took\n"
		var m = %UserPrefsController.user_prefs.speedrunPB_m
		var s = %UserPrefsController.user_prefs.speedrunPB_s
		if m < 10:
			m = "0" + str(%UserPrefsController.user_prefs.speedrunPB_m)
		if s < 10:
			s = "0" + str(%UserPrefsController.user_prefs.speedrunPB_s)
		text += str(%UserPrefsController.user_prefs.speedrunPB_h) + ":" + str(m) + ":" + str(s) + "." + str(%UserPrefsController.user_prefs.speedrunPB_ms) + "  -  personal  best  hike  completion  time\n"
		if %UserPrefsController.user_prefs.difficulty_dropdown_index == 0:
			text += str(%UserPrefsController.user_prefs.biggest_relaxed_fall) + "  ft  -  longest  fall  taken  this  hike\n"
		elif %UserPrefsController.user_prefs.difficulty_dropdown_index == 1:
			text += str(%UserPrefsController.user_prefs.biggest_foddian_fall) + "  ft  -  longest  fall  taken  this  hike\n"
		elif %UserPrefsController.user_prefs.difficulty_dropdown_index == 2:
			text += str(%UserPrefsController.user_prefs.biggest_permadeath_fall) + "  ft  -  longest  fall  taken  this  hike\n"
		if get_parent().get_parent().name.contains("Driving"):
			text += "0  ft  -  "
		elif get_parent().get_parent().name.contains("Summit"):
			text += "2835  ft  -  "
		elif get_parent().get_parent().name.contains("Space"):
			text += "?????  ft  -  "
		text += "height  above  sea  level  this  hike  ended  at\n"
		if get_parent().get_parent().name.contains("Driving"):
			text += "'the driving ending'" + "\n"
		elif get_parent().get_parent().name.contains("Summit"):
			text += "'the dregs ending'" + "\n"
		elif get_parent().get_parent().name.contains("Space"):
			text += "'the drifting ending'" + "\n"
	if !%DialogueBox.visible:
		fade_in()
	pass

func fade_in():
	if count % 10 == 0 && modulate.a < 1:
		count += 1
		colorCount += 0.1
		modulate.a = colorCount
	elif modulate.a < 1:
		count += 1
	elif modulate.a >= 1:
		modulate.a = 1
	pass
