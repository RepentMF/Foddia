extends Control

@onready var crt = $CanvasLayer2
@onready var music_slider = %MusicSlider
@onready var sfx_slider = %SFXSlider
@onready var voice_acting_checkbox = %VoiceActingCheckBox
@onready var radio_songs_checkbox = %RadioSongsChangeBool

var cursor_highlighted = -100

func _ready():
	get_node("OptionSelect").play()
	if music_slider:
		music_slider.value = %UserPrefsController.user_prefs.music_audio_level
	if sfx_slider:
		sfx_slider.value = %UserPrefsController.user_prefs.sfx_audio_level
	if voice_acting_checkbox:
		voice_acting_checkbox.button_pressed = %UserPrefsController.user_prefs.voice_acting_bool_check
	if radio_songs_checkbox:
		radio_songs_checkbox.button_pressed = %UserPrefsController.user_prefs.radio_songs_bool_check
	if %UserPrefsController.user_prefs.crt_bool_check:
		crt.visible = true
		%Node2D2.position = Vector2(5.50012, 70.25)
		%Node2D3.position = Vector2(19.0001, 79.7499)
		%Node2D4.position = Vector2(1.00012, 81.9999)
		%Node2D5.position = Vector2(-3, 86)
	else:
		crt.visible = false
		%Node2D2.position = Vector2(5.50006, 61.75)
		%Node2D3.position = Vector2(19.0001, 71.25)
		%Node2D4.position = Vector2(1.00006, 73.5)
		%Node2D5.position = Vector2(-3.00006, 77.5)

func _process(delta):
	use_keyboard_or_gamepad()
	get_node("OptionSelect").volume_db = %SFXVolumeHandler.SFX_volume
	pass

func use_keyboard_or_gamepad():
	if (Input.is_action_just_pressed("ui_up") || Input.is_action_just_pressed("ui_down")) && cursor_highlighted == -100:
		cursor_highlighted = 0
	elif cursor_highlighted == -101:
		%"Return to Main Menu".release_focus()
		%VoiceActingCheckBox.release_focus()
		%RadioSongsChangeBool.release_focus()
		%MusicSlider.release_focus()
		%SFXSlider.release_focus()
		cursor_highlighted = -100
	elif cursor_highlighted != -100:
		if cursor_highlighted > -1:
			if Input.is_action_just_pressed("ui_up"):
				cursor_highlighted -= 1
		if cursor_highlighted < 3:
			if Input.is_action_just_pressed("ui_down"):
				cursor_highlighted += 1
		if cursor_highlighted == -1:
			%"Return to Main Menu".grab_focus()
		#elif cursor_highlighted == 0:
		#	%VoiceActingCheckBox.grab_focus()
		elif cursor_highlighted == 0:
			%RadioSongsChangeBool.grab_focus()
		elif cursor_highlighted == 1:
			%MusicSlider.grab_focus()
		elif cursor_highlighted == 2:
			%SFXSlider.grab_focus()

func _on_return_to_main_menu_pressed():
	get_tree().change_scene_to_file("res://Menus/MainMenu.tscn")
	pass # Replace with function body.

func _on_music_slider_value_changed(value):
	if %UserPrefsController.user_prefs:
		%UserPrefsController.user_prefs.music_audio_level = value
		%UserPrefsController.user_prefs.save()
	pass # Replace with function body.

func _on_sfx_slider_value_changed(value):
	if %UserPrefsController.user_prefs:
		%UserPrefsController.user_prefs.sfx_audio_level = value
		%UserPrefsController.user_prefs.save()
	pass # Replace with function body.

func _on_voice_acting_check_button_toggled(button_pressed):
	if %UserPrefsController.user_prefs:
		%UserPrefsController.user_prefs.voice_acting_bool_check = button_pressed
		%UserPrefsController.user_prefs.save()
	pass # Replace with function body.
	
func _on_radio_songs_change_bool_toggled(button_pressed):
	if %UserPrefsController.user_prefs:
		%UserPrefsController.user_prefs.radio_songs_bool_check = button_pressed
		%UserPrefsController.user_prefs.save()
	pass # Replace with function body.

func _on_mouse_entered():
	cursor_highlighted = -101
	pass # Replace with function body.
