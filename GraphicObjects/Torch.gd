extends AnimatedSprite2D

func _on_area_2d_area_exited(area):
	if area.name.contains("Reveal"):
		get_node("PointLight2D").visible = true
	pass # Replace with function body.
