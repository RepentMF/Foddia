extends Control

var user_prefs: UserPreferences

var colorCount = 1
var count = 1
var dialogue
var elisia
var indexer = 0
var interacting = true
var rng
var stars
var textCount = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	user_prefs = UserPreferences.load_or_create()
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
	if user_prefs.difficulty_dropdown_index == 0:
		if !user_prefs.relaxed_boots_flag && !user_prefs.relaxed_rockets_flag && !user_prefs.relaxed_jetpack_flag:
			elisia.play("human_floating")
		if user_prefs.relaxed_boots_flag && !user_prefs.relaxed_rockets_flag && !user_prefs.relaxed_jetpack_flag:
			elisia.play("robot_floating")
		elif !user_prefs.relaxed_boots_flag && user_prefs.relaxed_rockets_flag && !user_prefs.relaxed_jetpack_flag:
			elisia.play("rocket_floating")
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
	pass