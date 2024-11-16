extends Node2D

var carEngine

# Called when the node enters the scene tree for the first time.
func _ready():
	carEngine = get_node("CarEngine")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if !carEngine.is_playing():
		carEngine.play()
	pass
