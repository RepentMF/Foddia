extends CanvasLayer

var cursor_highlighted = -100
var started = false

var user_prefs: UserPreferences

# Called when the node enters the scene tree for the first time.
func _ready():
	user_prefs = UserPreferences.load_or_create()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if !visible:
		started = false
	else:
		use_keyboard_or_gamepad()
	pass

func use_keyboard_or_gamepad():
	# Keyboard support - 8 if elses each
	# Controller support - 8 if elses each
	if Input.is_action_just_pressed("ui_left") || Input.is_action_just_pressed("ui_right") || Input.is_action_just_pressed("ui_down") || Input.is_action_just_pressed("ui_up"):
		get_node("ControllerDisplay/Analog_DPAD_Shoulders").modulate.a = 1
		if get_tree().root.get_child(0).name == "MainMenu":
			get_tree().root.get_node("MainMenu/CanvasLayer/MarginContainer/DialogueBox").get_node("RichTextLabel").text = get_node("ControllerDisplay/Analog_DPAD_Shoulders").get_meta("Tooltip")
		else:
			get_tree().root.get_node("Overworld/UIHolder/DialogueBox").get_node("RichTextLabel").text = get_node("ControllerDisplay/Analog_DPAD_Shoulders").get_meta("Tooltip")
	elif Input.is_action_just_pressed("ui_select"):
		get_node("ControllerDisplay/Triggers").modulate.a = 1
		if get_tree().root.get_child(0).name == "MainMenu":
			get_tree().root.get_node("MainMenu/CanvasLayer/MarginContainer/DialogueBox").get_node("RichTextLabel").text = get_node("ControllerDisplay/Triggers").get_meta("Tooltip")
		else:
			get_tree().root.get_node("Overworld/UIHolder/DialogueBox").get_node("RichTextLabel").text = get_node("ControllerDisplay/Triggers").get_meta("Tooltip")
	elif Input.is_action_just_pressed("ui_map"):
		get_node("ControllerDisplay/Select").modulate.a = 1
		if get_tree().root.get_child(0).name == "MainMenu":
			get_tree().root.get_node("MainMenu/CanvasLayer/MarginContainer/DialogueBox").get_node("RichTextLabel").text = get_node("ControllerDisplay/Select").get_meta("Tooltip")
		else:
			get_tree().root.get_node("Overworld/UIHolder/DialogueBox").get_node("RichTextLabel").text = get_node("ControllerDisplay/Select").get_meta("Tooltip")
	elif Input.is_action_just_pressed("ui_menu"):
		get_node("ControllerDisplay/Pause").modulate.a = 1
		if get_tree().root.get_child(0).name == "MainMenu":
			get_tree().root.get_node("MainMenu/CanvasLayer/MarginContainer/DialogueBox").get_node("RichTextLabel").text = get_node("ControllerDisplay/Pause").get_meta("Tooltip")
		else:
			get_tree().root.get_node("Overworld/UIHolder/DialogueBox").get_node("RichTextLabel").text = get_node("ControllerDisplay/Pause").get_meta("Tooltip")
	pass
