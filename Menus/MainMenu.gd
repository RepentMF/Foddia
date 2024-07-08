extends Control

@onready var difficulty_dropdown = %ChangeDifficulty

var user_prefs: UserPreferences

var colorCount = 0
var count = 1
var load = false

func _ready():
	user_prefs = UserPreferences.load_or_create()
	if user_prefs.fullscreen_bool_check:
		get_window().mode = Window.MODE_FULLSCREEN
	else:
		get_window().mode = Window.MODE_WINDOWED
	if difficulty_dropdown:
		difficulty_dropdown.selected = user_prefs.difficulty_dropdown_index
	pass

func _physics_process(delta):
	if load:
		load_game()
	pass

func _on_new_game_pressed():
	if get_node("MarginContainer/VBoxContainer/ChangeDifficulty").get_selected_id() == 0:
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
	elif get_node("MarginContainer/VBoxContainer/ChangeDifficulty").get_selected_id() == 1:
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
	load = true
	pass # Replace with function body.

func _on_start_game_pressed():
	load = true
	pass # Replace with function body.

func _on_change_difficulty_item_selected(index):
	if user_prefs:
		user_prefs.difficulty_dropdown_index = index
		user_prefs.save()
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
	
func load_game():
	if count % 10 == 0 && $ColorRect.color.a < 1:
		count += 1
		colorCount += 0.1
		$ColorRect.color.a = colorCount
	elif $ColorRect.color.a < 1:
		count += 1
	elif $ColorRect.color.a == 1:
		get_tree().change_scene_to_file("res://game.tscn")
