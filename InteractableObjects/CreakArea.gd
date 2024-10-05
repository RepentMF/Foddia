extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_creak_area_entered(area):
	if area.get_parent() != null && area.name.contains("Hands"):
		if area.get_parent().hasReleasedRope:
			get_node("RopeReleased").play(0)
		elif area.get_parent().swingRope != null:
			if name.contains("Left"):
				get_node("RopeSwung").pitch_scale = 1.1
			elif name.contains("Right"):
				get_node("RopeSwung").pitch_scale = 1.2
			get_node("RopeSwung").play(0)
	pass # Replace with function body.
