extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if name.contains("Billboard"):
		if get_parent().indexer == get_meta("TutorialComponents")[3]:
			visible = true
		else:
			visible = false
	pass
