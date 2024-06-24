extends Node2D

@onready var anim = $AnimatedSprite2D

var pos = Vector2(0, 0)

# Called when the node enters the scene tree for the first time.
func _ready():
	pos = global_position
	rotation = randf_range(0, 359)
	print(rotation)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position = pos
	if !anim.is_playing():
		queue_free()
	pass
