extends Area2D

func _on_area_entered(area):
	if area.name.contains("Cloud"):
		area.position.x = area.starting_position
	pass # Replace with function body.
