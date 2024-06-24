extends CanvasLayer

@onready var crt_checkbox = %CRTFilterCheckBox
@onready var fullscreen_checkbox = %FullscreenCheckBox
@onready var speedrun_checkbox = %SpeedrunCheckButton
@onready var music_slider = %MusicSlider
@onready var sfx_slider = %SFXSlider

var user_prefs: UserPreferences

func _ready():
	user_prefs = UserPreferences.load_or_create()
	if user_prefs.fullscreen_bool_check:
		get_window().mode = Window.MODE_FULLSCREEN
	else:
		get_window().mode = Window.MODE_WINDOWED
	pass

func _process(delta):
	if user_prefs.fullscreen_bool_check:
		get_window().mode = Window.MODE_FULLSCREEN
	else:
		get_window().mode = Window.MODE_WINDOWED
	pass

func _on_keep_hiking_pressed():
	if  name == "PauseMenu" && get_tree().paused:
		get_tree().paused = false
		visible = false
	pass # Replace with function body.

func _on_go_to_display_menu_pressed():
	%PauseOptions.visible = false
	%GraphicsOptions.visible = true
	if crt_checkbox:
		crt_checkbox.button_pressed = user_prefs.crt_bool_check
	if fullscreen_checkbox:
		fullscreen_checkbox.button_pressed = user_prefs.fullscreen_bool_check
	if speedrun_checkbox:
		speedrun_checkbox.button_pressed = user_prefs.speedrun_bool_check
	pass # Replace with function body.

func _on_fullscreen_check_box_toggled(button_pressed):
	if user_prefs:
		user_prefs.fullscreen_bool_check = button_pressed
		user_prefs.save()
	pass # Replace with function body.
	
func _on_crt_filter_check_box_toggled(button_pressed):
	if user_prefs:
		user_prefs.crt_bool_check = button_pressed
		user_prefs.save()
	pass # Replace with function body.

func _on_speedrun_check_button_toggled(button_pressed):
	if user_prefs:
		user_prefs.speedrun_bool_check = button_pressed
		user_prefs.save()
	pass # Replace with function body.

func _on_go_to_audio_menu_pressed():
	%PauseOptions.visible = false
	%AudioOptions.visible = true
	if music_slider:
		music_slider.value = user_prefs.music_audio_level
	if sfx_slider:
		sfx_slider.value = user_prefs.sfx_audio_level
	pass # Replace with function body.

func _on_music_slider_value_changed(value):
	if user_prefs:
		user_prefs.music_audio_level = value
		user_prefs.save()
	pass # Replace with function body.

func _on_sfx_slider_value_changed(value):
	if user_prefs:
		user_prefs.sfx_audio_level = value
		user_prefs.save()
	pass # Replace with function body.

func _on_return_to_main_menu_pressed():
	%PauseOptions.visible = true
	%GraphicsOptions.visible = false
	%AudioOptions.visible = false
	pass # Replace with function body.

func _on_new_game_pressed():
	user_prefs.new_game = true
	user_prefs.save()
	get_tree().paused = false
	visible = false
	get_tree().reload_current_scene()
	pass # Replace with function body.

func _on_back_to_the_car_pressed():
	get_tree().paused = false
	visible = false
	get_tree().change_scene_to_file("res://Menus/MainMenu.tscn")
	pass # Replace with function body.
	
func _on_quit_game_pressed():
	get_tree().quit()
	pass # Replace with function body.
