extends Control

var user_prefs: UserPreferences

var colorCount = 1
var count = 1
var dialogue
var finishCount = 500
var indexer = 0
var interacting = true
var textCount = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	user_prefs = UserPreferences.load_or_create()
	_difficulty_sprite_determiner()
	%DialogueBox.get_node("RichTextLabel").text = dialogue[indexer]
	textCount = dialogue.size()
	if (user_prefs.relaxed_macguffin_flag && user_prefs.difficulty_dropdown_index == 0) || (user_prefs.foddian_macguffin_flag && user_prefs.difficulty_dropdown_index == 1) || (user_prefs.permadeath_macguffin_flag && user_prefs.difficulty_dropdown_index == 2):
		%Macguffin.visible = true
	if (user_prefs.relaxed_macguffin2_flag && user_prefs.difficulty_dropdown_index == 0) || (user_prefs.foddian_macguffin2_flag && user_prefs.difficulty_dropdown_index == 1) || (user_prefs.permadeath_macguffin2_flag && user_prefs.difficulty_dropdown_index == 2):
		%Macguffin2.visible = true
	if (user_prefs.relaxed_macguffin3_flag && user_prefs.difficulty_dropdown_index == 0) || (user_prefs.foddian_macguffin3_flag && user_prefs.difficulty_dropdown_index == 1) || (user_prefs.permadeath_macguffin3_flag && user_prefs.difficulty_dropdown_index == 2):
		%Macguffin3.visible = true
	if user_prefs.crt_bool_check:
		$CanvasLayer2.visible = true
	%TimerDisplay.ending = true
	if user_prefs.speedrun_bool_check:
		%TimerDisplay.visible = true
	else:
		%TimerDisplay.visible = false
	if user_prefs.achievement_dice:
		get_node("ItemString").visible = true
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if count % 10 == 0 && $ColorRect.color.a > 0:
		count += 1
		colorCount -= 0.1
		$ColorRect.color.a = colorCount
	elif $ColorRect.color.a > 0:
		count += 1
	elif $ColorRect.color.a <= 0:
		$ColorRect.color.a = 0
	
	if !interacting:
		if finishCount <= 0:
			$CanvasLayer3/MarginContainer.visible = true
		elif finishCount > 0:
			finishCount -= 1
	
	if Input.is_action_just_released("ui_click"):
		if interacting:
			indexer += 1
			if indexer < textCount:
				%DialogueBox.visible = true
				%DialogueBox.get_node("RichTextLabel").text = dialogue[indexer]
			elif indexer == textCount:
				indexer = 0
				%DialogueBox.visible = false
				interacting = false
	pass

func _difficulty_sprite_determiner():
	if user_prefs.difficulty_dropdown_index == 0:
		if user_prefs.relaxed_macguffin3_flag:
			dialogue = %MainMenuBg.get_meta("Macguffin3")
			%Macguffin3.visible = true
		elif user_prefs.relaxed_macguffin_flag:
			dialogue = %MainMenuBg.get_meta("Macguffin")
			%Macguffin.visible = true
		%TimerDisplay.ms = user_prefs.relaxed_ms
		%TimerDisplay.s = user_prefs.relaxed_s
		%TimerDisplay.m = user_prefs.relaxed_m
		%TimerDisplay.h = user_prefs.relaxed_h
	elif user_prefs.difficulty_dropdown_index == 1:
		if user_prefs.foddian_macguffin3_flag:
			dialogue = %MainMenuBg.get_meta("Macguffin3")
			%Macguffin3.visible = true
		elif user_prefs.foddian_macguffin_flag:
			dialogue = %MainMenuBg.get_meta("Macguffin")
		%TimerDisplay.ms = user_prefs.foddian_ms
		%TimerDisplay.s = user_prefs.foddian_s
		%TimerDisplay.m = user_prefs.foddian_m
		%TimerDisplay.h = user_prefs.foddian_h
	elif user_prefs.difficulty_dropdown_index == 2:
		if user_prefs.permadeath_macguffin3_flag:
			dialogue = %MainMenuBg.get_meta("Macguffin3")
			%Macguffin3.visible = true
		elif user_prefs.permadeath_macguffin_flag:
			dialogue = %MainMenuBg.get_meta("Macguffin")
		%TimerDisplay.ms = user_prefs.permadeath_ms
		%TimerDisplay.s = user_prefs.permadeath_s
		%TimerDisplay.m = user_prefs.permadeath_m
		%TimerDisplay.h = user_prefs.permadeath_h
	pass

func _on_quit_game_pressed():
	get_tree().quit()
	pass # Replace with function body.
