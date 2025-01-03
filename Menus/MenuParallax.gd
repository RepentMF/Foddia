extends Sprite2D

var user_prefs: UserPreferences

var looping_position
var starting_position
var speed

# Called when the node enters the scene tree for the first time.
func _ready():
	user_prefs = UserPreferences.load_or_create()
	looping_position = get_meta("looping_position")
	starting_position = get_meta("starting_position")
	if get_parent().name == "DrivingEnding":
		speed = get_meta("speed")
	else:
		speed = get_meta("Speed")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if (user_prefs.screenshake_bool_check || (get_parent().name == "DrivingEnding")) && speed != null:
		position.x -= speed
		if position.x == looping_position:
			position.x = starting_position
	pass
