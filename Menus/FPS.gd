extends RichTextLabel

var lowest = 30

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if !%Player.game_start:
		if Engine.get_frames_per_second() < lowest:
			lowest = Engine.get_frames_per_second()
	if visible:
		text = str("FPS - Current: ", Engine.get_frames_per_second(), ", Lowest: ", lowest)
	
	if Input.is_action_just_pressed("ui_fps"):
		if visible:
			visible = false
		else:
			visible = true
	pass
