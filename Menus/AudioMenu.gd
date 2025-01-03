extends Control

@onready var crt = $CanvasLayer2
@onready var music_slider = %MusicSlider
@onready var sfx_slider = %SFXSlider
@onready var voice_acting_checkbox = %VoiceActingCheckBox

var user_prefs: UserPreferences

func _ready():
	user_prefs = UserPreferences.load_or_create()
	if user_prefs != null:
		print(user_prefs.music_audio_level, user_prefs.sfx_audio_level)
	if music_slider:
		music_slider.value = user_prefs.music_audio_level
	if sfx_slider:
		sfx_slider.value = user_prefs.sfx_audio_level
	if voice_acting_checkbox:
		voice_acting_checkbox.button_pressed = user_prefs.voice_acting_bool_check
	if user_prefs.crt_bool_check:
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

func _on_return_to_main_menu_pressed():
	get_tree().change_scene_to_file("res://Menus/MainMenu.tscn")
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
