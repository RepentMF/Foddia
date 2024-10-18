extends Control

var user_prefs: UserPreferences
var rs

var colorCount = 1
var count = 1
var dialogue
var elisia
var finishCount = 500
var indexer = 0
var interacting = true
var rng
var stars
var textCount = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	user_prefs = UserPreferences.load_or_create()
	rs = RenderingServer
	rs.set_default_clear_color(Color (.145, .286, .509, 1))
	elisia = get_node("Elisia")
	_difficulty_sprite_determiner()
	%DialogueBox.get_node("RichTextLabel").text = dialogue[indexer]
	textCount = dialogue.size()
	if (user_prefs.relaxed_macguffin_flag && user_prefs.difficulty_dropdown_index == 0) || (user_prefs.foddian_macguffin_flag && user_prefs.difficulty_dropdown_index == 1) || (user_prefs.permadeath_macguffin_flag && user_prefs.difficulty_dropdown_index == 2):
		%Macguffin.visible = true
	if (user_prefs.relaxed_macguffin2_flag && user_prefs.difficulty_dropdown_index == 0) || (user_prefs.foddian_macguffin2_flag && user_prefs.difficulty_dropdown_index == 1) || (user_prefs.permadeath_macguffin2_flag && user_prefs.difficulty_dropdown_index == 2):
		%Macguffin2.visible = true
	if user_prefs.crt_bool_check:
		$CanvasLayer2.visible = true
	%TimerDisplay.ending = true
	if user_prefs.speedrun_bool_check:
		%TimerDisplay.visible = true
	else:
		%TimerDisplay.visible = false
	if user_prefs.achievement_big_dipper:
		get_node("BigDipper").visible = true
		print("this worked, again")
	if user_prefs.achievement_little_dipper:
		get_node("LittleDipper").visible = true
	
	if !interacting:
		if finishCount <= 0:
			$CanvasLayer3/MarginContainer.visible = true
		elif finishCount > 0:
			finishCount -= 1
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
	dialogue = elisia.get_meta("DIALOGUE")
	if user_prefs.difficulty_dropdown_index == 0:
		if !user_prefs.relaxed_boots_flag && !user_prefs.relaxed_rockets_flag && !user_prefs.relaxed_jetpack_flag:
			elisia.play("human_sitting")
		if user_prefs.relaxed_boots_flag && !user_prefs.relaxed_rockets_flag && !user_prefs.relaxed_jetpack_flag:
			elisia.play("robot_sitting")
		elif !user_prefs.relaxed_boots_flag && user_prefs.relaxed_rockets_flag && !user_prefs.relaxed_jetpack_flag:
			elisia.play("rocket_sitting")
		elif !user_prefs.relaxed_boots_flag && !user_prefs.relaxed_rockets_flag && user_prefs.relaxed_jetpack_flag:
			elisia.play("jetpack_floating")
		if user_prefs.relaxed_boots_flag && user_prefs.relaxed_rockets_flag && !user_prefs.relaxed_jetpack_flag:
			elisia.play("RR_floating")
		elif user_prefs.relaxed_boots_flag && !user_prefs.relaxed_rockets_flag && user_prefs.relaxed_jetpack_flag:
			elisia.play("RJ_floating")
		elif !user_prefs.relaxed_boots_flag && user_prefs.relaxed_rockets_flag && user_prefs.relaxed_jetpack_flag:
			elisia.play("JR_floating")
		if user_prefs.relaxed_boots_flag && user_prefs.relaxed_rockets_flag && user_prefs.relaxed_jetpack_flag:
			elisia.play("RJR_floating")
			dialogue = elisia.get_meta("ROBOT")
		if user_prefs.relaxed_macguffin3_flag:
			dialogue = elisia.get_meta("MACGUFFIN3")
			%Macguffin3.visible = true
		elif user_prefs.relaxed_macguffin_flag:
			dialogue = elisia.get_meta("MACGUFFIN")
		elif user_prefs.relaxed_macguffin2_flag:
			dialogue = elisia.get_meta("MACGUFFIN2")
		%TimerDisplay.ms = user_prefs.relaxed_ms
		%TimerDisplay.s = user_prefs.relaxed_s
		%TimerDisplay.m = user_prefs.relaxed_m
		%TimerDisplay.h = user_prefs.relaxed_h
	elif user_prefs.difficulty_dropdown_index == 1:
		if !user_prefs.foddian_boots_flag && !user_prefs.foddian_rockets_flag && !user_prefs.foddian_jetpack_flag:
			elisia.play("human_floating")
		if user_prefs.foddian_boots_flag && !user_prefs.foddian_rockets_flag && !user_prefs.foddian_jetpack_flag:
			elisia.play("robot_floating")
		elif !user_prefs.foddian_boots_flag && user_prefs.foddian_rockets_flag && !user_prefs.foddian_jetpack_flag:
			elisia.play("rocket_floating")
		elif !user_prefs.foddian_boots_flag && !user_prefs.foddian_rockets_flag && user_prefs.foddian_jetpack_flag:
			elisia.play("jetpack_floating")
		if user_prefs.foddian_boots_flag && user_prefs.foddian_rockets_flag && !user_prefs.foddian_jetpack_flag:
			elisia.play("RR_floating")
		elif user_prefs.foddian_boots_flag && !user_prefs.foddian_rockets_flag && user_prefs.foddian_jetpack_flag:
			elisia.play("RJ_floating")
		elif !user_prefs.foddian_boots_flag && user_prefs.foddian_rockets_flag && user_prefs.foddian_jetpack_flag:
			elisia.play("JR_floating")
		if user_prefs.foddian_boots_flag && user_prefs.foddian_rockets_flag && user_prefs.foddian_jetpack_flag:
			elisia.play("RJR_floating")
			dialogue = elisia.get_meta("ROBOT")
		if user_prefs.foddian_macguffin3_flag:
			dialogue = elisia.get_meta("MACGUFFIN3")
			%Macguffin3.visible = true
		elif user_prefs.foddian_macguffin_flag:
			dialogue = elisia.get_meta("MACGUFFIN")
		elif user_prefs.foddian_macguffin2_flag:
			dialogue = elisia.get_meta("MACGUFFIN2")
		%TimerDisplay.ms = user_prefs.foddian_ms
		%TimerDisplay.s = user_prefs.foddian_s
		%TimerDisplay.m = user_prefs.foddian_m
		%TimerDisplay.h = user_prefs.foddian_h
	elif user_prefs.difficulty_dropdown_index == 2:
		if !user_prefs.permadeath_boots_flag && !user_prefs.permadeath_rockets_flag && !user_prefs.permadeath_jetpack_flag:
			elisia.play("human_floating")
		if user_prefs.permadeath_boots_flag && !user_prefs.permadeath_rockets_flag && !user_prefs.permadeath_jetpack_flag:
			elisia.play("robot_floating")
		elif !user_prefs.permadeath_boots_flag && user_prefs.permadeath_rockets_flag && !user_prefs.permadeath_jetpack_flag:
			elisia.play("rocket_floating")
		elif !user_prefs.permadeath_boots_flag && !user_prefs.permadeath_rockets_flag && user_prefs.permadeath_jetpack_flag:
			elisia.play("jetpack_floating")
		if user_prefs.permadeath_boots_flag && user_prefs.permadeath_rockets_flag && !user_prefs.permadeath_jetpack_flag:
			elisia.play("RR_floating")
		elif user_prefs.permadeath_boots_flag && !user_prefs.permadeath_rockets_flag && user_prefs.permadeath_jetpack_flag:
			elisia.play("RJ_floating")
		elif !user_prefs.permadeath_boots_flag && user_prefs.permadeath_rockets_flag && user_prefs.permadeath_jetpack_flag:
			elisia.play("JR_floating")
		if user_prefs.permadeath_boots_flag && user_prefs.permadeath_rockets_flag && user_prefs.permadeath_jetpack_flag:
			elisia.play("RJR_floating")
			dialogue = elisia.get_meta("ROBOT")
		if user_prefs.permadeath_macguffin3_flag:
			dialogue = elisia.get_meta("MACGUFFIN3")
			%Macguffin3.visible = true
		elif user_prefs.permadeath_macguffin_flag:
			dialogue = elisia.get_meta("MACGUFFIN")
		elif user_prefs.permadeath_macguffin2_flag:
			dialogue = elisia.get_meta("MACGUFFIN2")
		%TimerDisplay.ms = user_prefs.permadeath_ms
		%TimerDisplay.s = user_prefs.permadeath_s
		%TimerDisplay.m = user_prefs.permadeath_m
		%TimerDisplay.h = user_prefs.permadeath_h
	pass


func _on_quit_game_pressed():
	get_tree().quit()
	pass # Replace with function body.
