extends Control

@onready var crt = $CanvasLayer2
@onready var crt_checkbox = %CRTFilterCheckBox
@onready var fullscreen_checkbox = %FullscreenCheckBox
@onready var speedrun_checkbox = %SpeedrunCheckButton
@onready var screenshake_checkbox = %ScreenshakeCheckButton
@onready var title_color = %ChangeTitleColor

var cursor_highlighted = -100
var temp_volume

var user_prefs: UserPreferences

func _ready():
	user_prefs = UserPreferences.load_or_create()
	get_node("OptionSelect").play()
	if crt_checkbox:
		crt_checkbox.button_pressed = user_prefs.crt_bool_check
	if fullscreen_checkbox:
		fullscreen_checkbox.button_pressed = user_prefs.fullscreen_bool_check
	if speedrun_checkbox:
		speedrun_checkbox.button_pressed = user_prefs.speedrun_bool_check
	if screenshake_checkbox:
		screenshake_checkbox.button_pressed = user_prefs.screenshake_bool_check
	if user_prefs.crt_bool_check:
		crt.visible = true
	else:
		crt.visible = false
	if title_color:
		title_color.selected = user_prefs.title_color_index
	pass

func _process(delta):
	use_keyboard_or_gamepad()
	
	if fullscreen_checkbox.button_pressed:
		get_window().mode = Window.MODE_FULLSCREEN
	else:
		get_window().mode = Window.MODE_WINDOWED
	pass

func _physics_process(delta):
	if temp_volume != %SFXVolumeHandler.SFX_volume:
		temp_volume = %SFXVolumeHandler.SFX_volume
		get_node("OptionSelect").volume_db = temp_volume
	pass

func use_keyboard_or_gamepad():
	print(cursor_highlighted)
	if (Input.is_action_just_pressed("ui_up") || Input.is_action_just_pressed("ui_down")) && cursor_highlighted == -100:
		cursor_highlighted = 0
	elif cursor_highlighted == -101:
		%"Return to Main Menu".release_focus()
		%FullscreenCheckBox.release_focus()
		%ScreenshakeCheckButton.release_focus()
		%CRTFilterCheckBox.release_focus()
		%SpeedrunCheckButton.release_focus()
		%ChangeTitleColor.release_focus()
		cursor_highlighted = -100
	elif cursor_highlighted != -100:
		if cursor_highlighted != 5:
			if cursor_highlighted > -1:
				if Input.is_action_just_pressed("ui_up"):
					cursor_highlighted -= 1
			if cursor_highlighted < 4:
				if Input.is_action_just_pressed("ui_down"):
					cursor_highlighted += 1
		if cursor_highlighted == -1:
			%"Return to Main Menu".grab_focus()
		elif cursor_highlighted == 0:
			%FullscreenCheckBox.grab_focus()
		elif cursor_highlighted == 1:
			%ScreenshakeCheckButton.grab_focus()
		elif cursor_highlighted == 2:
			%CRTFilterCheckBox.grab_focus()
		elif cursor_highlighted == 3:
			%SpeedrunCheckButton.grab_focus()
		elif cursor_highlighted == 4:
			%ChangeTitleColor.grab_focus()

func _on_return_to_main_menu_pressed():
	get_tree().change_scene_to_file("res://Menus/MainMenu.tscn")
	pass # Replace with function body.

func _on_fullscreen_check_box_toggled(button_pressed):
	if user_prefs:
		user_prefs.fullscreen_bool_check = button_pressed
		user_prefs.save()
	pass # Replace with function body.
	
func _on_crt_filter_check_box_toggled(button_pressed):
	if user_prefs:
		user_prefs.crt_bool_check = button_pressed
		if user_prefs.crt_bool_check:
			crt.visible = true
		else:
			crt.visible = false
		user_prefs.save()
	pass # Replace with function body.

func _on_speedrun_check_button_toggled(button_pressed):
	if user_prefs:
		user_prefs.speedrun_bool_check = button_pressed
		user_prefs.save()
	pass # Replace with function body.
	
func _on_screenshake_check_button_toggled(button_pressed):
	if user_prefs:
		user_prefs.screenshake_bool_check = button_pressed
		user_prefs.save()
	pass # Replace with function body.

func _on_change_title_color_item_selected(index):
	cursor_highlighted = -101
	if user_prefs:
		user_prefs.title_color_index = index
		user_prefs.save()
	pass # Replace with function body.

func _on_change_title_color_item_focused(index):
	cursor_highlighted = 5
	pass # Replace with function body.
