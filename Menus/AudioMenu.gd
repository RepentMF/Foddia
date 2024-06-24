extends Control

@onready var music_slider = %MusicSlider
@onready var sfx_slider = %SFXSlider

var user_prefs: UserPreferences

func _ready():
	user_prefs = UserPreferences.load_or_create()
	if music_slider:
		music_slider.value = user_prefs.music_audio_level
	if sfx_slider:
		sfx_slider.value = user_prefs.sfx_audio_level

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
