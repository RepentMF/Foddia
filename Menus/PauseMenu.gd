extends CanvasLayer

@onready var crt_checkbox = %CRTFilterCheckBox
@onready var fullscreen_checkbox = %FullscreenCheckBox
@onready var speedrun_checkbox = %SpeedrunCheckButton
@onready var music_slider = %MusicSlider
@onready var sfx_slider = %SFXSlider
@onready var voice_acting_checkbox = %VoiceActingCheckBox
@onready var radio_songs_checkbox = %RadioSongsCheckBox

var user_prefs: UserPreferences

var spoof_fullscreen_bool
var fullscreen_changed

func _ready():
	user_prefs = UserPreferences.load_or_create()
	fullscreen_changed = false
	if user_prefs.fullscreen_bool_check:
		get_window().mode = Window.MODE_FULLSCREEN
		spoof_fullscreen_bool = true
	else:
		get_window().mode = Window.MODE_WINDOWED
		spoof_fullscreen_bool = false
	pass

func _process(delta):
	if spoof_fullscreen_bool != user_prefs.fullscreen_bool_check:
		fullscreen_changed = true
	if fullscreen_changed:
		if user_prefs.fullscreen_bool_check:
			get_window().mode = Window.MODE_FULLSCREEN
			spoof_fullscreen_bool = true
		else:
			get_window().mode = Window.MODE_WINDOWED
			spoof_fullscreen_bool = false
		fullscreen_changed = false
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
	if voice_acting_checkbox:
		voice_acting_checkbox.button_pressed = user_prefs.voice_acting_bool_check
	if radio_songs_checkbox:
		radio_songs_checkbox.button_pressed = user_prefs.radio_songs_bool_check
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

func _on_voice_acting_check_button_toggled(button_pressed):
	if user_prefs:
		user_prefs.voice_acting_bool_check = button_pressed
		user_prefs.save()
	pass # Replace with function body.

func _on_radio_songs_check_box_toggled(button_pressed):
	if user_prefs:
		user_prefs.radio_songs_bool_check = button_pressed
		user_prefs.save()
	pass

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
	_save_player_info()
	get_tree().change_scene_to_file("res://Menus/MainMenu.tscn")
	pass # Replace with function body.
	
func _on_quit_game_pressed():
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()
	pass # Replace with function body.

func _save_player_info():
	if user_prefs.difficulty_dropdown_index == 0:
		user_prefs.relaxed_save = %Player.global_position
		user_prefs.relaxed_checkpoint = %Player.checkpoint
		user_prefs.relaxed_boots_flag = %Player.hasNewLegs
		user_prefs.relaxed_rockets_flag = %Player.hasRocketJump
		user_prefs.relaxed_jetpack_flag = %Player.hasJetpack
		user_prefs.relaxed_fuel_count = %Player.countJetpackFuel
		user_prefs.relaxed_macguffin_flag = %Player.hasMacguffin
		user_prefs.relaxed_macguffin2_flag = %Player.hasMacguffin2
		user_prefs.relaxed_macguffin3_flag = %Player.hasMacguffin3
		user_prefs.relaxed_ms = %Player.timer.ms
		user_prefs.relaxed_s = %Player.timer.s
		user_prefs.relaxed_m = %Player.timer.m
		user_prefs.relaxed_h = %Player.timer.h
	elif user_prefs.difficulty_dropdown_index == 1:
		user_prefs.foddian_save = %Player.global_position
		user_prefs.foddian_checkpoint = %Player.checkpoint
		user_prefs.foddian_boots_flag = %Player.hasNewLegs
		user_prefs.foddian_rockets_flag = %Player.hasRocketJump
		user_prefs.foddian_jetpack_flag = %Player.hasJetpack
		user_prefs.foddian_fuel_count = %Player.countJetpackFuel
		user_prefs.foddian_macguffin_flag = %Player.hasMacguffin
		user_prefs.foddian_macguffin2_flag = %Player.hasMacguffin2
		user_prefs.foddian_macguffin3_flag = %Player.hasMacguffin3
		user_prefs.foddian_ms = %Player.timer.ms
		user_prefs.foddian_s = %Player.timer.s
		user_prefs.foddian_m = %Player.timer.m
		user_prefs.foddian_h = %Player.timer.h
	elif user_prefs.difficulty_dropdown_index == 2:
		user_prefs.permadeath_save = %Player.global_position
		user_prefs.permadeath_boots_flag = %Player.hasNewLegs
		user_prefs.permadeath_rockets_flag = %Player.hasRocketJump
		user_prefs.permadeath_jetpack_flag = %Player.hasJetpack
		user_prefs.permadeath_fuel_count = %Player.countJetpackFuel
		user_prefs.permadeath_macguffin_flag = %Player.hasMacguffin
		user_prefs.permadeath_macguffin2_flag = %Player.hasMacguffin2
		user_prefs.permadeath_macguffin3_flag = %Player.hasMacguffin3
		user_prefs.permadeath_ms = %Player.timer.ms
		user_prefs.permadeath_s = %Player.timer.s
		user_prefs.permadeath_m = %Player.timer.m
		user_prefs.permadeath_h = %Player.timer.h
	user_prefs.save()
