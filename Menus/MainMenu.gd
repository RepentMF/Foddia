extends Control

@onready var difficulty_dropdown = %ChangeDifficulty
@onready var crt = $CanvasLayer2

var colorCount = 0
var count = 1
var cursor_highlighted = -100
var gameStart = true
var load = false

func _ready():
	Engine.max_fps = 30
	%UserPrefsController.user_prefs.demo = false
	if %UserPrefsController.user_prefs.tooltips_bool_check:
		%TooltipsCheckBox.button_pressed = true
	else:
		%TooltipsCheckBox.button_pressed = false
	if %UserPrefsController.user_prefs.fullscreen_bool_check:
		get_window().mode = Window.MODE_FULLSCREEN
	else:
		get_window().mode = Window.MODE_WINDOWED
	if difficulty_dropdown:
		difficulty_dropdown.selected = %UserPrefsController.user_prefs.difficulty_dropdown_index
	if %UserPrefsController.user_prefs.crt_bool_check:
		crt.visible = true
	else:
		crt.visible = false
	if %UserPrefsController.user_prefs.bad_ending:
		%BadMainMenuBg.visible = true
		%MainMenuBg.visible = false
	else:
		%BadMainMenuBg.visible = false
		%MainMenuBg.visible = true
	
	if %UserPrefsController.user_prefs.achievement_dice:
		$ItemString.visible = true
	if (%UserPrefsController.user_prefs.relaxed_macguffin_flag && %UserPrefsController.user_prefs.difficulty_dropdown_index == 0) || (%UserPrefsController.user_prefs.foddian_macguffin_flag && %UserPrefsController.user_prefs.difficulty_dropdown_index == 1) || (%UserPrefsController.user_prefs.permadeath_macguffin_flag && %UserPrefsController.user_prefs.difficulty_dropdown_index == 2):
		%Macguffin.visible = true
	if (%UserPrefsController.user_prefs.relaxed_macguffin2_flag && %UserPrefsController.user_prefs.difficulty_dropdown_index == 0) || (%UserPrefsController.user_prefs.foddian_macguffin2_flag && %UserPrefsController.user_prefs.difficulty_dropdown_index == 1) || (%UserPrefsController.user_prefs.permadeath_macguffin2_flag && %UserPrefsController.user_prefs.difficulty_dropdown_index == 2):
		%Macguffin2.visible = true
	if (%UserPrefsController.user_prefs.relaxed_macguffin3_flag && %UserPrefsController.user_prefs.difficulty_dropdown_index == 0) || (%UserPrefsController.user_prefs.foddian_macguffin3_flag && %UserPrefsController.user_prefs.difficulty_dropdown_index == 1) || (%UserPrefsController.user_prefs.permadeath_macguffin3_flag && %UserPrefsController.user_prefs.difficulty_dropdown_index == 2):
		%Macguffin3.visible = true
	pass

func _physics_process(_delta):
	if !load:
		use_keyboard_or_gamepad()
	
	if !load:
		if gameStart:	
			gameStart = false
		if %UserPrefsController.user_prefs.demo:
			if %Title.texture != %Title.get_meta("Titles_demo")[%UserPrefsController.user_prefs.title_color_index]:
				%Title.texture = %Title.get_meta("Titles_demo")[%UserPrefsController.user_prefs.title_color_index]
		else:
			if %Title.texture != %Title.get_meta("Titles")[%UserPrefsController.user_prefs.title_color_index]:
				%Title.texture = %Title.get_meta("Titles")[%UserPrefsController.user_prefs.title_color_index]
		if !%UserPrefsController.user_prefs.demo && Steam.isSteamRunning():
			if %UserPrefsController.user_prefs.bad_ending && !%UserPrefsController.user_prefs.achievement_true:
				%UserPrefsController.user_prefs.achievement_true = true
				if !Steam.getAchievement("ACHIEVEMENT_TRUE")["achieved"]:
					Steam.setAchievement("ACHIEVEMENT_TRUE")
					Steam.storeStats()
	elif load:
		%Title.visible = true
		%Credits.visible = false
		%DialogueBox.visible = false
		%MainMenuBg.texture = %MainMenuNotLookingBg.texture
		load_game()
	pass

func use_keyboard_or_gamepad():
	if !%ButtonsDisplay.visible:
		if (Input.is_action_just_pressed("ui_up") || Input.is_action_just_pressed("ui_down")) && cursor_highlighted == -100:
			cursor_highlighted = 0
		elif cursor_highlighted == -101:
			%CreditsCheckBox.release_focus()
			%TooltipsCheckBox.release_focus()
			%"New Game".release_focus()
			%"Start Game".release_focus()
			%ChangeDifficulty.release_focus()
			%"Go to Display Menu".release_focus()
			%"Go to Audio Menu".release_focus()
			%"Quit Game".release_focus()
			cursor_highlighted = -100
		elif cursor_highlighted != -100:
			if cursor_highlighted != 7:
				if cursor_highlighted > -2:
					if Input.is_action_just_pressed("ui_up"):
						cursor_highlighted -= 1
				if cursor_highlighted < 6:
					if Input.is_action_just_pressed("ui_down"):
						cursor_highlighted += 1
			if %UserPrefsController.user_prefs.tooltips_bool_check && !%Credits.visible:
				%DialogueBox.visible = true
				%MainMenuBg.texture = %MainMenuLookingBg.texture
			elif %Credits.visible:
				%DialogueBox.visible = false
				%MainMenuBg.texture = %MainMenuCreditsLookingBg.texture
			else:
				%DialogueBox.visible = false
				%MainMenuBg.texture = %MainMenuNotLookingBg.texture
			if cursor_highlighted == -1:
				%TooltipsCheckBox.grab_focus()
				%DialogueBox.get_node("RichTextLabel").text = %TooltipsCheckBox.get_meta("Tooltip")
			elif cursor_highlighted == 0:
				%"New Game".grab_focus()
				%DialogueBox.get_node("RichTextLabel").text = %"New Game".get_meta("Tooltip")
			elif cursor_highlighted == 1:
				%"Start Game".grab_focus()
				%DialogueBox.get_node("RichTextLabel").text = %"Start Game".get_meta("Tooltip")
			elif cursor_highlighted == 2:
				%ChangeDifficulty.grab_focus()
				%DialogueBox.get_node("RichTextLabel").text = %ChangeDifficulty.get_meta("Tooltip")
			elif cursor_highlighted == 3:
				%ControllerLayout.grab_focus()
				%DialogueBox.get_node("RichTextLabel").text = %ControllerLayout.get_meta("Tooltip")
			elif cursor_highlighted == 4:
				%"Go to Display Menu".grab_focus()
				%DialogueBox.get_node("RichTextLabel").text = %"Go to Display Menu".get_meta("Tooltip")
			elif cursor_highlighted == 5:
				%"Go to Audio Menu".grab_focus()
				%DialogueBox.get_node("RichTextLabel").text = %"Go to Audio Menu".get_meta("Tooltip")
			elif cursor_highlighted == 6:
				%"Quit Game".grab_focus()
				%DialogueBox.get_node("RichTextLabel").text = %"Quit Game".get_meta("Tooltip")
	elif %ButtonsDisplay.visible && !%ButtonsDisplay.started:
		%ButtonsDisplay.started = true
		get_tree().root.get_node("MainMenu/CanvasLayer/MarginContainer/DialogueBox").get_node("RichTextLabel").text = ""
		get_tree().root.get_node("MainMenu/CanvasLayer/MarginContainer/DialogueBox").visible = true
		release_focus()

func _on_new_game_pressed():
	if !load:
		%StartGame.play()
		%UserPrefsController.user_prefs.bad_ending = false
		%UserPrefsController.user_prefs.dialogue_count = 0
		%UserPrefsController.user_prefs.teleportersAvailable = false
		if get_node("CanvasLayer/MarginContainer/VBoxContainer/ChangeDifficulty").get_selected_id() == 0:
			%UserPrefsController.user_prefs.relaxed_checkpoint = Vector2(260, 130)
			%UserPrefsController.user_prefs.relaxed_save = Vector2(260, 130)
			%UserPrefsController.user_prefs.relaxed_boots_flag = false
			%UserPrefsController.user_prefs.relaxed_rockets_flag = false
			%UserPrefsController.user_prefs.relaxed_jetpack_flag = false
			%UserPrefsController.user_prefs.relaxed_fuel_count = 1000
			%UserPrefsController.user_prefs.relaxed_macguffin_flag = false
			%UserPrefsController.user_prefs.relaxed_macguffin2_flag = false
			%UserPrefsController.user_prefs.relaxed_macguffin3_flag = false
			%UserPrefsController.user_prefs.relaxed_ms = 0
			%UserPrefsController.user_prefs.relaxed_s = 0
			%UserPrefsController.user_prefs.relaxed_m = 0
			%UserPrefsController.user_prefs.relaxed_h = 0
			%UserPrefsController.user_prefs.relaxed_flag1 = false
			%UserPrefsController.user_prefs.relaxed_flag2 = false
			%UserPrefsController.user_prefs.relaxed_flag3 = false
			%UserPrefsController.user_prefs.relaxed_flag4 = false
			%UserPrefsController.user_prefs.relaxed_flag5 = false
			%UserPrefsController.user_prefs.relaxed_flag6 = false
			%UserPrefsController.user_prefs.relaxed_flag7 = false
			%UserPrefsController.user_prefs.relaxed_flag8 = false
			%UserPrefsController.user_prefs.relaxed_flag9 = false
			%UserPrefsController.user_prefs.relaxed_flag10 = false
			%UserPrefsController.user_prefs.relaxed_flag11 = false
			%UserPrefsController.user_prefs.relaxed_flag12 = false
			%UserPrefsController.user_prefs.relaxed_flag13 = false
			%UserPrefsController.user_prefs.relaxed_flag14 = false
			%UserPrefsController.user_prefs.rel_last_song = "LostAgain"
			%UserPrefsController.user_prefs.rel_last_area = ""
			%UserPrefsController.user_prefs.save()
		elif get_node("CanvasLayer/MarginContainer/VBoxContainer/ChangeDifficulty").get_selected_id() == 1:
			%UserPrefsController.user_prefs.foddian_save = Vector2(260, 130)
			%UserPrefsController.user_prefs.foddian_boots_flag = false
			%UserPrefsController.user_prefs.foddian_rockets_flag = false
			%UserPrefsController.user_prefs.foddian_jetpack_flag = false
			%UserPrefsController.user_prefs.foddian_fuel_count = 1000
			%UserPrefsController.user_prefs.foddian_macguffin_flag = false
			%UserPrefsController.user_prefs.foddian_macguffin2_flag = false
			%UserPrefsController.user_prefs.foddian_macguffin3_flag = false
			%UserPrefsController.user_prefs.foddian_ms = 0
			%UserPrefsController.user_prefs.foddian_s = 0
			%UserPrefsController.user_prefs.foddian_m = 0
			%UserPrefsController.user_prefs.foddian_h = 0
			%UserPrefsController.user_prefs.fod_last_song = "LostAgain"
			%UserPrefsController.user_prefs.fod_last_area = ""
			%UserPrefsController.user_prefs.save()
		elif get_node("CanvasLayer/MarginContainer/VBoxContainer/ChangeDifficulty").get_selected_id() == 2:
			%UserPrefsController.user_prefs.permadeath_save = Vector2(260, 130)
			%UserPrefsController.user_prefs.permadeath_boots_flag = false
			%UserPrefsController.user_prefs.permadeath_rockets_flag = false
			%UserPrefsController.user_prefs.permadeath_jetpack_flag = false
			%UserPrefsController.user_prefs.permadeath_fuel_count = 1000
			%UserPrefsController.user_prefs.permadeath_macguffin_flag = false
			%UserPrefsController.user_prefs.permadeath_macguffin2_flag = false
			%UserPrefsController.user_prefs.permadeath_macguffin3_flag = false
			%UserPrefsController.user_prefs.permadeath_ms = 0
			%UserPrefsController.user_prefs.permadeath_s = 0
			%UserPrefsController.user_prefs.permadeath_m = 0
			%UserPrefsController.user_prefs.permadeath_h = 0
			%UserPrefsController.user_prefs.per_last_song = "LostAgain"
			%UserPrefsController.user_prefs.per_last_area = ""
			%UserPrefsController.user_prefs.save()
		%UserPrefsController.user_prefs.teleportersAvailable = false
		%UserPrefsController.user_prefs.dialogue_count = 0
		load = true
	pass # Replace with function body.

func _on_start_game_pressed():
	if !load:
		%StartGame.play()
		load = true
	pass # Replace with function body.

func _on_change_difficulty_item_selected(index):
	if !load:
		if %UserPrefsController.user_prefs:
			%UserPrefsController.user_prefs.difficulty_dropdown_index = index
			%UserPrefsController.user_prefs.save()
	pass # Replace with function body.

func _on_controller_layout_pressed():
	if !load:
		%ButtonsDisplay.visible = true
		get_tree().root.get_node("MainMenu/CanvasLayer/MarginContainer/DialogueBox").visible = true
		get_tree().root.get_node("MainMenu/CanvasLayer/MarginContainer/VBoxContainer").visible = false
		get_tree().root.get_node("MainMenu/CanvasLayer3").visible = false
		get_tree().root.get_node("MainMenu/Title").visible = false
	pass # Replace with function body.

func _on_go_to_display_menu_pressed():
	if !load:
		get_tree().change_scene_to_file("res://Menus/GraphicsMenu.tscn")
	pass # Replace with function body.

func _on_go_to_audio_menu_pressed():
	if !load:
		get_tree().change_scene_to_file("res://Menus/AudioMenu.tscn")
	pass # Replace with function body.

func _on_quit_game_pressed():
	if !load:
		get_tree().quit()
	pass # Replace with function body.

func _on_credits_check_box_toggled(toggled_on):
	if !load:
		if toggled_on:
			%Credits.visible = true
			%Title.visible = false
			%DialogueBox.visible = false
			%MainMenuBg.texture = %MainMenuCreditsLookingBg.texture
		else:
			%Credits.visible = false
			%Title.visible = true
			%MainMenuBg.texture = %MainMenuNotLookingBg.texture
	pass # Replace with function body.
	
func _on_tooltips_check_box_toggled(toggled_on):
	if !load:
		if toggled_on:
			%UserPrefsController.user_prefs.tooltips_bool_check = true
			if !gameStart && !%Credits.visible:
				%DialogueBox.get_node("RichTextLabel").text = %TooltipsCheckBox.get_meta("Tooltip")
				%DialogueBox.visible = true
				%MainMenuBg.texture = %MainMenuLookingBg.texture
		else:
			%UserPrefsController.user_prefs.tooltips_bool_check = false
			%DialogueBox.visible = false
			if %Credits.visible:
				%MainMenuBg.texture = %MainMenuCreditsLookingBg.texture
			else:
				%MainMenuBg.texture = %MainMenuNotLookingBg.texture
		%UserPrefsController.user_prefs.save()
	pass # Replace with function body.

func load_game():
	if count % 10 == 0 && $ColorRect.color.a < 1:
		count += 1
		colorCount += 0.1
		$ColorRect.color.a = colorCount
		$CanvasLayer/MarginContainer/VBoxContainer.modulate.a = $CanvasLayer/MarginContainer/VBoxContainer.modulate.a - 0.11
		$CanvasLayer3/Control/Credits.modulate.a = $CanvasLayer/MarginContainer/VBoxContainer.modulate.a - 0.06
		$CanvasLayer3/Control/CreditsCheckBox.modulate.a = $CanvasLayer/MarginContainer/VBoxContainer.modulate.a - 0.06
		$CanvasLayer3/Control/TooltipsCheckBox.modulate.a = $CanvasLayer/MarginContainer/VBoxContainer.modulate.a - 0.06
	elif $ColorRect.color.a < 1:
		count += 1
	elif $ColorRect.color.a == 1:
		if %UserPrefsController.user_prefs.demo:
			if %UserPrefsController.user_prefs.difficulty_dropdown_index == 0:
				get_tree().change_scene_to_file("res://Levels/OverworldRelaxed_demo.tscn")
			elif %UserPrefsController.user_prefs.difficulty_dropdown_index == 1:
				get_tree().change_scene_to_file("res://Levels/OverworldFoddian_demo.tscn")
			elif %UserPrefsController.user_prefs.difficulty_dropdown_index == 2:
				get_tree().change_scene_to_file("res://Levels/OverworldPermadeath_demo.tscn")
		else:
			if %UserPrefsController.user_prefs.difficulty_dropdown_index == 0:
				get_tree().change_scene_to_file("res://Levels/OverworldRelaxed.tscn")
			elif %UserPrefsController.user_prefs.difficulty_dropdown_index == 1:
				get_tree().change_scene_to_file("res://Levels/OverworldFoddian.tscn")
			elif %UserPrefsController.user_prefs.difficulty_dropdown_index == 2:
				get_tree().change_scene_to_file("res://Levels/OverworldPermadeath.tscn")

func _on_change_difficulty_item_focused(_index):
	cursor_highlighted = 7
	pass # Replace with function body.
