extends Area2D

var alpha
var cloud_speed
var golden_ratio
var starting_position
var h_color_modifier = .6
var s_color_modifier
var v_color_modifier

# Called when the node enters the scene tree for the first time.
func _ready():
	if abs(position.y) > 11000 && z_index > 0:
		alpha = .6
	else:
		alpha = 1
	golden_ratio = (snapped(-1 * (position.y / 20000.0), .01))
	cloud_speed = .1 + (golden_ratio * 10)
	starting_position = -735
	if abs(position.y) > 11000 && z_index < 0:
		h_color_modifier = 0
		v_color_modifier = 1
		if %UserPrefsController.user_prefs.difficulty_dropdown_index == 0:
			s_color_modifier = 0
		elif %UserPrefsController.user_prefs.difficulty_dropdown_index == 1:
			h_color_modifier = .6
			s_color_modifier = golden_ratio
			v_color_modifier = 1 - (golden_ratio / 7)
		elif %UserPrefsController.user_prefs.difficulty_dropdown_index == 2:
			s_color_modifier = (golden_ratio * 2) + .6
	else:
		if %UserPrefsController.user_prefs.difficulty_dropdown_index == 0:
			s_color_modifier = golden_ratio
		elif %UserPrefsController.user_prefs.difficulty_dropdown_index == 1:
			s_color_modifier = (golden_ratio * .5) + .3
		elif %UserPrefsController.user_prefs.difficulty_dropdown_index == 2:
			s_color_modifier = (golden_ratio * 1.5) + .7
		v_color_modifier = 1 - (golden_ratio / 10)
	scale.x = scale.x + (golden_ratio * 10)
	scale.y = scale.y + (golden_ratio * 10)
	modulate = Color.from_hsv(h_color_modifier, s_color_modifier, v_color_modifier, alpha)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	position.x += cloud_speed
	pass
