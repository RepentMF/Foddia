extends Node2D

var rs

# Called when the node enters the scene tree for the first time.
func _ready():
	Engine.max_fps = 240
	if %UserPrefsController.user_prefs.fullscreen_bool_check:
		get_window().mode = Window.MODE_FULLSCREEN
	else:
		get_window().mode = Window.MODE_WINDOWED
	rs = RenderingServer
	rs.set_default_clear_color(Color (0, 0, 0, 1))
	%TBG_video.volume_db = %Control.OST_volume
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if !%TBG_video.is_playing():
		get_tree().change_scene_to_file("res://Menus/MainMenu.tscn")
	pass
