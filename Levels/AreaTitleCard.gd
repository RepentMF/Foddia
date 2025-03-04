extends RichTextLabel

var user_prefs: UserPreferences

var fadeInCount
var fadeInMax
var fadeOutCount
var fadeOutMax
var waitCount
var waitMax
var startCount
var repeat
var shown

var current_string
var player
var title_card_text
var titles

# Called when the node enters the scene tree for the first time.
func _ready():
	user_prefs = UserPreferences.load_or_create()
	if user_prefs.difficulty_dropdown_index == 0:
		current_string = user_prefs.rel_last_area
	elif user_prefs.difficulty_dropdown_index == 1:
		current_string = user_prefs.fod_last_area
	elif user_prefs.difficulty_dropdown_index == 2:
		current_string = user_prefs.per_last_area
	fadeInCount = 0
	fadeInMax = 280
	fadeOutCount = 0
	fadeOutMax = 280
	waitCount = 0
	waitMax = 300
	shown = false
	repeat = false
	startCount = 0
	player = %Player
	title_card_text = ""
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if title_card_text != current_string && repeat && shown:
		title_card_text = current_string
		repeat = false
		shown = false
	if player.countHangTime < 30:
		if !shown:
			choose_area()
	pass

func choose_area():
	if !repeat:
		if !shown:
			text = title_card_text
			if fadeInCount < fadeInMax:
				fadeInCount += 1
				if fadeInCount % 20 == 0:
					modulate.a += .0745
					if modulate.a > 1:
						modulate.a = 1
			elif waitCount < waitMax:
				waitCount += 1
			elif fadeOutCount < fadeOutMax:
				fadeOutCount += 1
				if fadeOutCount % 20 == 0:
					modulate.a -= .0745
					if modulate.a < 0:
						modulate.a = 0
						startCount = 0
						fadeInCount = 0
						fadeOutCount = 0
						waitCount = 0
						shown = true
						repeat = true
	else:
		repeat = false
		startCount = 0
	pass
