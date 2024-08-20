extends Sprite2D

var looping_position
var starting_position
var speed

# Called when the node enters the scene tree for the first time.
func _ready():
	looping_position = get_meta("looping_position")
	starting_position = get_meta("starting_position")
	speed = get_meta("speed")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	position.x -= speed
	if position.x == looping_position:
		position.x = starting_position
	pass
