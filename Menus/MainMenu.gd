extends Control

func _on_start_game_pressed():
	get_tree().change_scene_to_file("res://Levels/Overworld.tscn")
	pass # Replace with function body.

func _on_go_to_display_menu_pressed():
	get_tree().change_scene_to_file("res://Menus/GraphicsMenu.tscn")
	pass # Replace with function body.

func _on_go_to_audio_menu_pressed():
	get_tree().change_scene_to_file("res://Menus/AudioMenu.tscn")
	pass # Replace with function body.

func _on_quit_game_pressed():
	get_tree().quit()
	pass # Replace with function body.
