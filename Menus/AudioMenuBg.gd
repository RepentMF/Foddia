extends Sprite2D

var random

var bounce = 0
var count = 0
var move = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if %UserPrefsController.user_prefs.screenshake_bool_check:
		random = RandomNumberGenerator.new().randi_range(0, 100)
		if random >= 91 && bounce == 0:
			move = 1
			bounce = 2
			count = 0
			position = Vector2(647, 403)
		
		if count % 2:
			position.y += move
		else:
			position.y -= move
		
		if bounce > 0:
			bounce -= 1
		else:
			move = 2
		count += 1
	pass
