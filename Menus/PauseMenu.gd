extends CanvasLayer

@onready var crt_checkbox = %CRTFilterCheckBox
@onready var fullscreen_checkbox = %FullscreenCheckBox
@onready var speedrun_checkbox = %SpeedrunCheckButton
@onready var music_slider = %MusicSlider
@onready var sfx_slider = %SFXSlider
@onready var voice_acting_checkbox = %VoiceActingCheckBox
@onready var radio_songs_checkbox = %RadioSongsCheckBox

var user_prefs: UserPreferences

var cursor_highlighted = -100
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
	if user_prefs.title_color_index == 0:
		get_node("ColorRect1").visible = true
		get_node("ColorRect2").visible = false
		get_node("ColorRect3").visible = false
		get_node("ColorRect4").visible = false
		get_node("ColorRect5").visible = false
		get_node("ColorRect6").visible = false
	elif user_prefs.title_color_index == 1:
		get_node("ColorRect1").visible = false
		get_node("ColorRect2").visible = true
		get_node("ColorRect3").visible = false
		get_node("ColorRect4").visible = false
		get_node("ColorRect5").visible = false
		get_node("ColorRect6").visible = false
	elif user_prefs.title_color_index == 2:
		get_node("ColorRect1").visible = false
		get_node("ColorRect2").visible = false
		get_node("ColorRect3").visible = true
		get_node("ColorRect4").visible = false
		get_node("ColorRect5").visible = false
		get_node("ColorRect6").visible = false
	elif user_prefs.title_color_index == 3:
		get_node("ColorRect1").visible = false
		get_node("ColorRect2").visible = false
		get_node("ColorRect3").visible = false
		get_node("ColorRect4").visible = true
		get_node("ColorRect5").visible = false
		get_node("ColorRect6").visible = false
	elif user_prefs.title_color_index == 4:
		get_node("ColorRect1").visible = false
		get_node("ColorRect2").visible = false
		get_node("ColorRect3").visible = false
		get_node("ColorRect4").visible = false
		get_node("ColorRect5").visible = true
		get_node("ColorRect6").visible = false
	elif user_prefs.title_color_index == 5:
		get_node("ColorRect1").visible = false
		get_node("ColorRect2").visible = false
		get_node("ColorRect3").visible = false
		get_node("ColorRect4").visible = false
		get_node("ColorRect5").visible = false
		get_node("ColorRect6").visible = true
	pass

func _process(delta):
	if Input.is_action_just_pressed("ui_menu") && !%Player.pausePressed:
		visible = true
	elif Input.is_action_just_pressed("ui_menu") && %Player.pausePressed:
		_on_keep_hiking_pressed()
	
	use_keyboard_or_gamepad()
	
	if user_prefs.difficulty_dropdown_index == 0 && !%"Reset Checkpoint".visible:
		%"Reset Checkpoint".visible = true
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
	
	if user_prefs.hasMP3:
		%ChangeSong.get_parent().visible = true
		%MP3.get_parent().visible = true
		if user_prefs.hasSong1:
			%ChangeSong.set_item_text(1, "Lost Again")
			%ChangeSong.set_item_disabled(1, false)
		if user_prefs.hasSong2:
			%ChangeSong.set_item_text(2, "Don't Look Down")
			%ChangeSong.set_item_disabled(2, false)
		if user_prefs.hasSong3:
			%ChangeSong.set_item_text(3, "Test of Patience")
			%ChangeSong.set_item_disabled(3, false)
		if user_prefs.hasSong4:
			%ChangeSong.set_item_text(4, "Trials Abound")
			%ChangeSong.set_item_disabled(4, false)
		if user_prefs.hasSong5:
			%ChangeSong.set_item_text(5, "Can't Turn Back")
			%ChangeSong.set_item_disabled(5, false)
		if user_prefs.hasSong6:
			%ChangeSong.set_item_text(6, "Painful Longing")
			%ChangeSong.set_item_disabled(6, false)
		if user_prefs.hasSong7:
			%ChangeSong.set_item_text(7, "May the Stars Follow You")
			%ChangeSong.set_item_disabled(7, false)
		if user_prefs.hasSong8:
			%ChangeSong.set_item_text(8, "Gnawing Desires")
			%ChangeSong.set_item_disabled(8, false)
		if %ChangeSong.selected != 0:
			%RadioPlayer.mp3Song = true
			%RadioPlayer.songHasStarted = false
		elif %ChangeSong.selected == 0:
			%RadioPlayer.mp3Song = false
			%RadioPlayer.songHasStarted = true
	pass

func use_keyboard_or_gamepad():
	if (Input.is_action_just_pressed("ui_up") || Input.is_action_just_pressed("ui_down")) && cursor_highlighted == -100:
		cursor_highlighted = 0
	elif cursor_highlighted == -101:
		if %PauseOptions.visible:
			%"Keep Hiking".release_focus()
			%"Reset Checkpoint".release_focus()
			%"Go to Display Menu".release_focus()
			%"Go to Audio Menu".release_focus()
			%"New Game".release_focus()
			%"Back to the Car".release_focus()
			%"Quit Game".release_focus()
		elif %GraphicsOptions.visible:
			%"Return to Pause Menu".release_focus()
			%"FullscreenCheckBox".release_focus()
			%CRTFilterCheckBox.release_focus()
			%SpeedrunCheckButton.release_focus()
		elif %AudioOptions.visible:
			%"Return to Pause Menu 2".release_focus()
			%MusicSlider.release_focus()
			%SFXSlider.release_focus()
			%VoiceActingCheckBox.release_focus()
			%RadioSongsCheckBox.release_focus()
		cursor_highlighted = -100
	elif cursor_highlighted != -100:
		if %PauseOptions.visible:
			if cursor_highlighted > -1:
				if Input.is_action_just_pressed("ui_up"):
					cursor_highlighted -= 1
			if user_prefs.difficulty_dropdown_index == 0:
				if cursor_highlighted < 6:
					if Input.is_action_just_pressed("ui_down"):
						cursor_highlighted += 1
				if cursor_highlighted == 0:
					%"Keep Hiking".grab_focus()
				elif cursor_highlighted == 1:
					%"Reset Checkpoint".grab_focus()
				elif cursor_highlighted == 2:
					%"Go to Display Menu".grab_focus()
				elif cursor_highlighted == 3:
					%"Go to Audio Menu".grab_focus()
				elif cursor_highlighted == 4:
					%"New Game".grab_focus()
				elif cursor_highlighted == 5:
					%"Back to the Car".grab_focus()
				elif cursor_highlighted == 6:
					%"Quit Game".grab_focus()
			else:
				if cursor_highlighted < 5:
					if Input.is_action_just_pressed("ui_down"):
						cursor_highlighted += 1
				if cursor_highlighted == 0:
					%"Keep Hiking".grab_focus()
				elif cursor_highlighted == 1:
					%"Go to Display Menu".grab_focus()
				elif cursor_highlighted == 2:
					%"Go to Audio Menu".grab_focus()
				elif cursor_highlighted == 3:
					%"New Game".grab_focus()
				elif cursor_highlighted == 4:
					%"Back to the Car".grab_focus()
				elif cursor_highlighted == 5:
					%"Quit Game".grab_focus()
		elif %GraphicsOptions.visible:
			if cursor_highlighted > -1:
				if Input.is_action_just_pressed("ui_up"):
					cursor_highlighted -= 1
			if cursor_highlighted < 3:
				if Input.is_action_just_pressed("ui_down"):
					cursor_highlighted += 1
			if cursor_highlighted == 0:
				%"Return to Pause Menu".grab_focus()
			elif cursor_highlighted == 1:
				%FullscreenCheckBox.grab_focus()
			elif cursor_highlighted == 2:
				%CRTFilterCheckBox.grab_focus()
			elif cursor_highlighted == 3:
				%SpeedrunCheckButton.grab_focus()
		elif %AudioOptions.visible:
			if cursor_highlighted > -1:
				if Input.is_action_just_pressed("ui_up"):
					cursor_highlighted -= 1
			if cursor_highlighted < 4:
				if Input.is_action_just_pressed("ui_down"):
					cursor_highlighted += 1
			if cursor_highlighted == 0:
				%"Return to Pause Menu 2".grab_focus()
			elif cursor_highlighted == 1:
				%MusicSlider.grab_focus()
			elif cursor_highlighted == 2:
				%SFXSlider.grab_focus()
			elif cursor_highlighted == 3:
				%VoiceActingCheckBox.grab_focus()
			elif cursor_highlighted == 4:
				%RadioSongsCheckBox.grab_focus()

func _on_keep_hiking_pressed():
	if  name == "PauseMenu" && get_tree().paused && %Player.pausePressed:
		cursor_highlighted = -100
		%AreaTitleCard.visible = true
		get_tree().paused = false
		visible = false
	pass # Replace with function body.

func _on_go_to_display_menu_pressed():
	%PauseOptions.visible = false
	%GraphicsOptions.visible = true
	cursor_highlighted = -100
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
	cursor_highlighted = -100
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
	cursor_highlighted = -100
	pass # Replace with function body.

func _on_new_game_pressed():
	user_prefs.new_game = true
	user_prefs.bad_ending = false
	user_prefs.dialogue_count = 0
	user_prefs.teleportersAvailable = false
	if user_prefs.difficulty_dropdown_index == 0:
		user_prefs.relaxed_checkpoint = Vector2(260, 130)
		user_prefs.relaxed_save = Vector2(260, 130)
		user_prefs.relaxed_boots_flag = false
		user_prefs.relaxed_rockets_flag = false
		user_prefs.relaxed_jetpack_flag = false
		user_prefs.relaxed_fuel_count = 1000
		user_prefs.relaxed_macguffin_flag = false
		user_prefs.relaxed_macguffin2_flag = false
		user_prefs.relaxed_macguffin3_flag = false
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
		user_prefs.rel_last_song = "LostAgain"
		user_prefs.rel_last_area = ""
	if user_prefs.difficulty_dropdown_index == 1:
		user_prefs.foddian_save = Vector2(260, 130)
		user_prefs.foddian_boots_flag = false
		user_prefs.foddian_rockets_flag = false
		user_prefs.foddian_jetpack_flag = false
		user_prefs.foddian_fuel_count = 1000
		user_prefs.foddian_macguffin_flag = false
		user_prefs.foddian_macguffin2_flag = false
		user_prefs.foddian_macguffin3_flag = false
		user_prefs.foddian_ms = 0
		user_prefs.foddian_s = 0
		user_prefs.foddian_m = 0
		user_prefs.foddian_h = 0
		user_prefs.fod_last_song = "LostAgain"
		user_prefs.fod_last_area = ""
	if user_prefs.difficulty_dropdown_index == 2:
		user_prefs.permadeath_save = Vector2(260, 130)
		user_prefs.permadeath_boots_flag = false
		user_prefs.permadeath_rockets_flag = false
		user_prefs.permadeath_jetpack_flag = false
		user_prefs.permadeath_fuel_count = 1000
		user_prefs.permadeath_macguffin_flag = false
		user_prefs.permadeath_macguffin2_flag = false
		user_prefs.permadeath_macguffin3_flag = false
		user_prefs.permadeath_ms = 0
		user_prefs.permadeath_s = 0
		user_prefs.permadeath_m = 0
		user_prefs.permadeath_h = 0
		user_prefs.per_last_song = "LostAgain"
		user_prefs.per_last_area = ""
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

func _on_mouse_entered():
	cursor_highlighted = -101
	pass # Replace with function body.

func _on_reset_checkpoint_pressed() -> void:
	%Player.forceDied = true
	if  name == "PauseMenu" && get_tree().paused && %Player.pausePressed:
		cursor_highlighted = -100
		get_tree().paused = false
		visible = false
	pass # Replace with function body.
