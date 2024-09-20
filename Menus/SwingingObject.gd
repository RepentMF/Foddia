extends Sprite2D

var user_prefs: UserPreferences

var rotation_diff
var swing_right = true

# Called when the node enters the scene tree for the first time.
func _ready():
	rotation_diff = -0.1
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print(rotation)
	
	if swing_right:
		rotation_diff = -0.1
	else:
		rotation_diff = 0.1
	
	rotation += rotation_diff
	
	if abs(rotation) >= 0.53:
		swing_right = swing_right * -1
	pass
