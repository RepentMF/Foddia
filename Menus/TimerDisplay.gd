extends RichTextLabel

var count = 0
var ending = false

var ms = 0
var s = 0
var m = 0
var h = 0

var sec = ""
var min = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	if ms > 9:
		s += 1
		ms = 0
	if s > 59:
		m += 1
		s = 0
	if m > 59:
		h += 1
		m = 0
	
	if s < 10:
		sec = str("0", s)
	else:
		sec = str(s)
	if m < 10:
		min = str("0", m)
	else:
		min = str(m)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if !get_owner().name.contains("Ending"):
		if %Player.fadeInCount <= 0:
			visible = %UserPrefsController.user_prefs.speedrun_bool_check
			if count < 1:
				if ms > 9:
					s += 1
					ms = 0
				if s > 59:
					m += 1
					s = 0
				if m > 59:
					h += 1
					m = 0
				
				if s < 10:
					sec = str("0", s)
				else:
					sec = str(s)
				if m < 10:
					min = str("0", m)
				else:
					min = str(m)
				set_text(str(h) + ":" + min + ":" + sec + "." + str(ms))
	else:
		#visible = %UserPrefsController.user_prefs.speedrun_bool_check
		if count < 1:
			if ms > 9:
				s += 1
				ms = 0
			if s > 59:
				m += 1
				s = 0
			if m > 59:
				h += 1
				m = 0
			
			if s < 10:
				sec = str("0", s)
			else:
				sec = str(s)
			if m < 10:
				min = str("0", m)
			else:
				min = str(m)
			set_text(str(h) + ":" + min + ":" + sec + "." + str(ms))
		if h < %UserPrefsController.user_prefs.speedrunPB_h:
			set_new_PB()
		elif h == %UserPrefsController.user_prefs.speedrunPB_h:
			if m < %UserPrefsController.user_prefs.speedrunPB_m:
				set_new_PB()
			elif m == %UserPrefsController.user_prefs.speedrunPB_m:
				if s < %UserPrefsController.user_prefs.speedrunPB_s:
					set_new_PB()
				elif s == %UserPrefsController.user_prefs.speedrunPB_s:
					if ms < %UserPrefsController.user_prefs.speedrunPB_ms:
						set_new_PB()
		if ending:
			count += 1
	pass

func _on_timer_timeout():
	if !ending:
		ms += 1
	pass # Replace with function body.

func set_new_PB():
	%UserPrefsController.user_prefs.speedrunPB_h = h
	%UserPrefsController.user_prefs.speedrunPB_m = m
	%UserPrefsController.user_prefs.speedrunPB_s = s
	%UserPrefsController.user_prefs.speedrunPB_ms = ms
	%UserPrefsController.user_prefs.save()
	pass
