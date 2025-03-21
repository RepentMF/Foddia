extends Control

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
	elisia = get_node("Elisia")
	_difficulty_sprite_determiner()
	%DialogueBox.get_node("RichTextLabel").text = dialogue[indexer]
	textCount = dialogue.size()
	if (%UserPrefsController.user_prefs.relaxed_macguffin_flag && %UserPrefsController.user_prefs.difficulty_dropdown_index == 0) || (%UserPrefsController.user_prefs.foddian_macguffin_flag && %UserPrefsController.user_prefs.difficulty_dropdown_index == 1) || (%UserPrefsController.user_prefs.permadeath_macguffin_flag && %UserPrefsController.user_prefs.difficulty_dropdown_index == 2):
		%Macguffin.visible = true
	if (%UserPrefsController.user_prefs.relaxed_macguffin2_flag && %UserPrefsController.user_prefs.difficulty_dropdown_index == 0) || (%UserPrefsController.user_prefs.foddian_macguffin2_flag && %UserPrefsController.user_prefs.difficulty_dropdown_index == 1) || (%UserPrefsController.user_prefs.permadeath_macguffin2_flag && %UserPrefsController.user_prefs.difficulty_dropdown_index == 2):
		%Macguffin2.visible = true
	if %UserPrefsController.user_prefs.crt_bool_check:
		$CanvasLayer2.visible = true
	%TimerDisplay.ending = true
	if %UserPrefsController.user_prefs.speedrun_bool_check:
		%TimerDisplay.visible = true
	else:
		%TimerDisplay.visible = false
	if %UserPrefsController.user_prefs.achievement_big_dipper:
		get_node("BigDipper").visible = true
	if %UserPrefsController.user_prefs.achievement_little_dipper:
		get_node("LittleDipper").visible = true
	
	rng = RandomNumberGenerator.new()
	rng.randomize()
	stars = get_node("Stars")
	for i in stars.get_child_count():
		stars.get_child(i).frame = rng.randi_range(0, 3)
		stars.get_child(i).speed_scale = rng. randf_range(0.8, 1.1)
		if stars.get_child(i).name.contains("Large"):
			stars.get_child(i).get_node("PointLight2D").energy = 1.75
			if stars.get_child(i).name != "LargeStar1":
				stars.get_child(i).get_node("PointLight2D").texture_scale = 2
			else:
				stars.get_child(i).get_node("PointLight2D").texture_scale = 2
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if !interacting:
		if finishCount <= 0:
			$CanvasLayer3/MarginContainer.visible = true
		elif finishCount > 0:
			finishCount -= 1
	
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
	elisia.rotation += 0.0004
	elisia.position.x -= 0.01
	elisia.position.y -= 0.03
	if elisia.scale.x > 0:
		elisia.scale.x -= 0.0005
		elisia.scale.y -= 0.0005
	
	%Macguffin2.rotation += 0.007
	%Macguffin2.position.x += .05
	%Macguffin2.position.y -= .05
	if %Macguffin2.scale.x > 0:
		%Macguffin2.scale.x -= 0.001
		%Macguffin2.scale.y -= 0.001
	pass

func _difficulty_sprite_determiner():
	dialogue = elisia.get_meta("DIALOGUE")
	if %UserPrefsController.user_prefs.difficulty_dropdown_index == 0:
		if !%UserPrefsController.user_prefs.relaxed_boots_flag && !%UserPrefsController.user_prefs.relaxed_rockets_flag && !%UserPrefsController.user_prefs.relaxed_jetpack_flag:
			elisia.play("human_floating")
		if %UserPrefsController.user_prefs.relaxed_boots_flag && !%UserPrefsController.user_prefs.relaxed_rockets_flag && !%UserPrefsController.user_prefs.relaxed_jetpack_flag:
			elisia.play("robot_floating")
		elif !%UserPrefsController.user_prefs.relaxed_boots_flag && %UserPrefsController.user_prefs.relaxed_rockets_flag && !%UserPrefsController.user_prefs.relaxed_jetpack_flag:
			elisia.play("rocket_floating")
		elif !%UserPrefsController.user_prefs.relaxed_boots_flag && !%UserPrefsController.user_prefs.relaxed_rockets_flag && %UserPrefsController.user_prefs.relaxed_jetpack_flag:
			elisia.play("jetpack_floating")
		if %UserPrefsController.user_prefs.relaxed_boots_flag && %UserPrefsController.user_prefs.relaxed_rockets_flag && !%UserPrefsController.user_prefs.relaxed_jetpack_flag:
			elisia.play("RR_floating")
		elif %UserPrefsController.user_prefs.relaxed_boots_flag && !%UserPrefsController.user_prefs.relaxed_rockets_flag && %UserPrefsController.user_prefs.relaxed_jetpack_flag:
			elisia.play("RJ_floating")
		elif !%UserPrefsController.user_prefs.relaxed_boots_flag && %UserPrefsController.user_prefs.relaxed_rockets_flag && %UserPrefsController.user_prefs.relaxed_jetpack_flag:
			elisia.play("JR_floating")
		if %UserPrefsController.user_prefs.relaxed_boots_flag && %UserPrefsController.user_prefs.relaxed_rockets_flag && %UserPrefsController.user_prefs.relaxed_jetpack_flag:
			elisia.play("RJR_floating")
			dialogue = elisia.get_meta("ROBOT")
		if %UserPrefsController.user_prefs.relaxed_macguffin3_flag:
			dialogue = elisia.get_meta("MACGUFFIN3")
			%Macguffin3.visible = true
		elif %UserPrefsController.user_prefs.relaxed_macguffin_flag:
			dialogue = elisia.get_meta("MACGUFFIN")
		elif %UserPrefsController.user_prefs.relaxed_macguffin2_flag:
			dialogue = elisia.get_meta("MACGUFFIN2")
		%TimerDisplay.ms = %UserPrefsController.user_prefs.relaxed_ms
		%TimerDisplay.s = %UserPrefsController.user_prefs.relaxed_s
		%TimerDisplay.m = %UserPrefsController.user_prefs.relaxed_m
		%TimerDisplay.h = %UserPrefsController.user_prefs.relaxed_h
	elif %UserPrefsController.user_prefs.difficulty_dropdown_index == 1:
		if !%UserPrefsController.user_prefs.foddian_boots_flag && !%UserPrefsController.user_prefs.foddian_rockets_flag && !%UserPrefsController.user_prefs.foddian_jetpack_flag:
			elisia.play("human_floating")
		if %UserPrefsController.user_prefs.foddian_boots_flag && !%UserPrefsController.user_prefs.foddian_rockets_flag && !%UserPrefsController.user_prefs.foddian_jetpack_flag:
			elisia.play("robot_floating")
		elif !%UserPrefsController.user_prefs.foddian_boots_flag && %UserPrefsController.user_prefs.foddian_rockets_flag && !%UserPrefsController.user_prefs.foddian_jetpack_flag:
			elisia.play("rocket_floating")
		elif !%UserPrefsController.user_prefs.foddian_boots_flag && !%UserPrefsController.user_prefs.foddian_rockets_flag && %UserPrefsController.user_prefs.foddian_jetpack_flag:
			elisia.play("jetpack_floating")
		if %UserPrefsController.user_prefs.foddian_boots_flag && %UserPrefsController.user_prefs.foddian_rockets_flag && !%UserPrefsController.user_prefs.foddian_jetpack_flag:
			elisia.play("RR_floating")
		elif %UserPrefsController.user_prefs.foddian_boots_flag && !%UserPrefsController.user_prefs.foddian_rockets_flag && %UserPrefsController.user_prefs.foddian_jetpack_flag:
			elisia.play("RJ_floating")
		elif !%UserPrefsController.user_prefs.foddian_boots_flag && %UserPrefsController.user_prefs.foddian_rockets_flag && %UserPrefsController.user_prefs.foddian_jetpack_flag:
			elisia.play("JR_floating")
		if %UserPrefsController.user_prefs.foddian_boots_flag && %UserPrefsController.user_prefs.foddian_rockets_flag && %UserPrefsController.user_prefs.foddian_jetpack_flag:
			elisia.play("RJR_floating")
			dialogue = elisia.get_meta("ROBOT")
		if %UserPrefsController.user_prefs.foddian_macguffin3_flag:
			dialogue = elisia.get_meta("MACGUFFIN3")
			%Macguffin3.visible = true
		elif %UserPrefsController.user_prefs.foddian_macguffin_flag:
			dialogue = elisia.get_meta("MACGUFFIN")
		elif %UserPrefsController.user_prefs.foddian_macguffin2_flag:
			dialogue = elisia.get_meta("MACGUFFIN2")
		%TimerDisplay.ms = %UserPrefsController.user_prefs.foddian_ms
		%TimerDisplay.s = %UserPrefsController.user_prefs.foddian_s
		%TimerDisplay.m = %UserPrefsController.user_prefs.foddian_m
		%TimerDisplay.h = %UserPrefsController.user_prefs.foddian_h
	elif %UserPrefsController.user_prefs.difficulty_dropdown_index == 2:
		if !%UserPrefsController.user_prefs.permadeath_boots_flag && !%UserPrefsController.user_prefs.permadeath_rockets_flag && !%UserPrefsController.user_prefs.permadeath_jetpack_flag:
			elisia.play("human_floating")
		if %UserPrefsController.user_prefs.permadeath_boots_flag && !%UserPrefsController.user_prefs.permadeath_rockets_flag && !%UserPrefsController.user_prefs.permadeath_jetpack_flag:
			elisia.play("robot_floating")
		elif !%UserPrefsController.user_prefs.permadeath_boots_flag && %UserPrefsController.user_prefs.permadeath_rockets_flag && !%UserPrefsController.user_prefs.permadeath_jetpack_flag:
			elisia.play("rocket_floating")
		elif !%UserPrefsController.user_prefs.permadeath_boots_flag && !%UserPrefsController.user_prefs.permadeath_rockets_flag && %UserPrefsController.user_prefs.permadeath_jetpack_flag:
			elisia.play("jetpack_floating")
		if %UserPrefsController.user_prefs.permadeath_boots_flag && %UserPrefsController.user_prefs.permadeath_rockets_flag && !%UserPrefsController.user_prefs.permadeath_jetpack_flag:
			elisia.play("RR_floating")
		elif %UserPrefsController.user_prefs.permadeath_boots_flag && !%UserPrefsController.user_prefs.permadeath_rockets_flag && %UserPrefsController.user_prefs.permadeath_jetpack_flag:
			elisia.play("RJ_floating")
		elif !%UserPrefsController.user_prefs.permadeath_boots_flag && %UserPrefsController.user_prefs.permadeath_rockets_flag && %UserPrefsController.user_prefs.permadeath_jetpack_flag:
			elisia.play("JR_floating")
		if %UserPrefsController.user_prefs.permadeath_boots_flag && %UserPrefsController.user_prefs.permadeath_rockets_flag && %UserPrefsController.user_prefs.permadeath_jetpack_flag:
			elisia.play("RJR_floating")
			dialogue = elisia.get_meta("ROBOT")
		if %UserPrefsController.user_prefs.permadeath_macguffin3_flag:
			dialogue = elisia.get_meta("MACGUFFIN3")
			%Macguffin3.visible = true
		elif %UserPrefsController.user_prefs.permadeath_macguffin_flag:
			dialogue = elisia.get_meta("MACGUFFIN")
		elif %UserPrefsController.user_prefs.permadeath_macguffin2_flag:
			dialogue = elisia.get_meta("MACGUFFIN2")
		%TimerDisplay.ms = %UserPrefsController.user_prefs.permadeath_ms
		%TimerDisplay.s = %UserPrefsController.user_prefs.permadeath_s
		%TimerDisplay.m = %UserPrefsController.user_prefs.permadeath_m
		%TimerDisplay.h = %UserPrefsController.user_prefs.permadeath_h
	pass


func _on_quit_game_pressed():
	get_tree().quit()
	pass # Replace with function body.
