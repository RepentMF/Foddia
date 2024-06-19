extends Control

func _process(delta):
	print(get_node("MarginContainer/VBoxContainer/Change Difficulty").get_selected_id())
	pass

func _on_start_game_pressed():
	if get_node("MarginContainer/VBoxContainer/Change Difficulty").get_selected_id() == 0:
		get_tree().change_scene_to_file("res://Levels/OverworldRelaxed.tscn")
	elif get_node("MarginContainer/VBoxContainer/Change Difficulty").get_selected_id() == 1:
		get_tree().change_scene_to_file("res://Levels/OverworldFoddian.tscn")
	elif get_node("MarginContainer/VBoxContainer/Change Difficulty").get_selected_id() == 2:
		get_tree().change_scene_to_file("res://Levels/OverworldPermadeath.tscn")
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
#res://Menus/MainMenu.tscn
#res://Levels/Overworld.tscn
