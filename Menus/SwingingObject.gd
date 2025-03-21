extends Sprite2D

var item_string

var rotation_diff
var x_diff
var swing_right = true

# Called when the node enters the scene tree for the first time.
func _ready():
	if %UserPrefsController.user_prefs.achievement_dice:
		get_parent().visible = true
	else:
		get_parent().visible = false
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	item_string = get_parent()
	if %UserPrefsController.user_prefs.screenshake_bool_check:
		item_string.play("swinging")
		if swing_right:
			rotation_diff = -0.0349066
			x_diff = .5
		else:
			rotation_diff = 0.0349066
			x_diff = -.5
		
		rotation += rotation_diff
		position.x += x_diff
		
		if abs(rotation) >= .52:
			if swing_right:
				swing_right = false
			elif !swing_right:
				swing_right = true
	else:
		item_string.play("idle")
	pass
