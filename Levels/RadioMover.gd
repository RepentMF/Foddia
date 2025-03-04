extends Node2D

var move = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if %RadioInfo.stop:
		move = false
	if move && get_node("RadioInfo").count < 94:
		position.x -= 1.5
	elif move:
		position.x -= .737
	pass
