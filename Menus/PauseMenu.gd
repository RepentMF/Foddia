extends Control

var user_prefs: UserPreferences

func _ready():
	user_prefs = UserPreferences.load_or_create()
	if user_prefs.fullscreen_bool_check:
		get_window().mode = Window.MODE_FULLSCREEN
	else:
		get_window().mode = Window.MODE_WINDOWED
	pass

func _on_keep_hiking_pressed():
	if  name == "PauseMenu" && get_tree().paused:
		get_tree().paused = false
		visible = false
		print("unpause")
	pass # Replace with function body.

func _on_go_to_display_menu_pressed():
	print("ya")
	get_tree().change_scene_to_file("res://Menus/GraphicsMenu.tscn")
	pass # Replace with function body.

func _on_go_to_audio_menu_pressed():
	get_tree().change_scene_to_file("res://Menus/AudioMenu.tscn")
	pass # Replace with function body.

func _on_new_game_pressed():
	if user_prefs.difficulty_dropdown_index == 0:
		user_prefs.relaxed_checkpoint = Vector2(260, 130)
		user_prefs.relaxed_save = Vector2(260, 130)
		user_prefs.relaxed_boots_flag = false
		user_prefs.relaxed_rockets_flag = false
		user_prefs.relaxed_jetpack_flag = false
		user_prefs.relaxed_fuel_count = 1000
		user_prefs.relaxed_macguffin_flag = false
		user_prefs.relaxed_macguffin2_flag = false
		user_prefs.relaxed_ms = 0
		user_prefs.relaxed_s = 0
		user_prefs.relaxed_m = 0
		user_prefs.relaxed_h = 0
		user_prefs.relaxed_flag1 = false
		user_prefs.relaxed_flag2 = false
		user_prefs.relaxed_flag3 = false
		user_prefs.relaxed_flag4 = false
		user_prefs.relaxed_flag5 = false
		user_prefs.relaxed_flag6 = false
		user_prefs.relaxed_flag7 = false
		user_prefs.relaxed_flag8 = false
		user_prefs.relaxed_flag9 = false
		user_prefs.relaxed_flag10 = false
		user_prefs.relaxed_flag11 = false
		user_prefs.relaxed_flag12 = false
		user_prefs.relaxed_flag13 = false
		user_prefs.relaxed_flag14 = false
		user_prefs.save()
	elif user_prefs.difficulty_dropdown_index == 1:
		user_prefs.foddian_save = Vector2(260, 130)
		user_prefs.foddian_boots_flag = false
		user_prefs.foddian_rockets_flag = false
		user_prefs.foddian_jetpack_flag = false
		user_prefs.foddian_fuel_count = 1000
		user_prefs.foddian_macguffin_flag = false
		user_prefs.foddian_macguffin2_flag = false
		user_prefs.foddian_ms = 0
		user_prefs.foddian_s = 0
		user_prefs.foddian_m = 0
		user_prefs.foddian_h = 0
		user_prefs.foddian_flag1 = false
		user_prefs.foddian_flag11 = false
		user_prefs.save()
	get_tree().change_scene_to_file("res://game.tscn")
	pass # Replace with function body.

func _on_back_to_the_car_pressed():
	get_tree().change_scene_to_file("res://Menus/MainMenu")
	pass # Replace with function body.
	
func _on_quit_game_pressed():
	get_tree().quit()
	pass # Replace with function body.
