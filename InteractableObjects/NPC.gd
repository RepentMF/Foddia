extends AnimatedSprite2D

@onready var player = %Player

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player.hasMacguffin2:
		play("dead")
	elif player.hasMacguffin:
		play("relieved")
	pass
