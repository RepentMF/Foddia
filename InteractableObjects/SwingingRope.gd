extends Node2D

@onready var left = $UI_Sprite2D_left
@onready var right = $UI_Sprite2D_right

# Called when the node enters the scene tree for the first time.
func _ready():
	left.visible = false
	right.visible = false
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if %Player.swingRope != null:
		if %Player.swingRope.get_parent().name == name:
			print(name)
			left.visible = true
			right.visible = true
		else:
			left.visible = false
			right.visible = false
	pass
