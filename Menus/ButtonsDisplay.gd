extends CanvasLayer

var last_selected = ""
var controls = "Controller"
var current_selected = ""
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
	use_controller()
	use_keyboard()
	
	if current_selected != last_selected && (controls == "Keyboard" || controls == "Controller"):
		if current_selected != "Arrows":
			get_node("KeyboardDisplay/Arrows").modulate.a = 0
		if current_selected != "C":
			get_node("KeyboardDisplay/C").modulate.a = 0
		if current_selected != "M":
			get_node("KeyboardDisplay/M").modulate.a = 0
		if current_selected != "Escape":
			get_node("KeyboardDisplay/Escape").modulate.a = 0
		if current_selected != "X":
			get_node("KeyboardDisplay/X").modulate.a = 0
		if current_selected != "Space":
			get_node("KeyboardDisplay/Space").modulate.a = 0
		if current_selected != "Enter":
			get_node("KeyboardDisplay/Enter").modulate.a = 0
		if current_selected != "WASD":
			get_node("KeyboardDisplay/WASD").modulate.a = 0
		if current_selected != "Analog_DPAD_Shoulders":
			get_node("ControllerDisplay/Analog_DPAD_Shoulders").modulate.a = 0
		if current_selected != "Triggers":
			get_node("ControllerDisplay/Triggers").modulate.a = 0
		if current_selected != "Select":
			get_node("ControllerDisplay/Select").modulate.a = 0
		if current_selected != "Pause":
			get_node("ControllerDisplay/Pause").modulate.a = 0
		if current_selected != "TopFace":
			get_node("ControllerDisplay/TopFace").modulate.a = 0
		if current_selected != "RightFace":
			get_node("ControllerDisplay/RightFace").modulate.a = 0
		if current_selected != "BottomFace":
			get_node("ControllerDisplay/BottomFace").modulate.a = 0
		if current_selected != "AnalogRight":
			get_node("ControllerDisplay/AnalogRight").modulate.a = 0
		last_selected = current_selected
	
	if controls == "Keyboard":
		get_node("KeyboardDisplay").visible = true
		get_node("ControllerDisplay").visible = false
	elif controls == "Controller":
		get_node("KeyboardDisplay").visible = false
		get_node("ControllerDisplay").visible = true
	else:
		#do nothing
		true
pass

func use_keyboard():
	if Input.is_key_pressed(KEY_LEFT) || Input.is_key_pressed(KEY_RIGHT) || Input.is_key_pressed(KEY_UP) || Input.is_key_pressed(KEY_DOWN):
		get_node("KeyboardDisplay/Arrows").modulate.a = 1
		current_selected = "Arrows"
		controls = "Keyboard"
		if get_tree().root.get_child(0).name == "MainMenu":
			get_tree().root.get_node("MainMenu/CanvasLayer/MarginContainer/DialogueBox").get_node("RichTextLabel").text = get_node("KeyboardDisplay/Arrows").get_meta("Tooltip")
		else:
			get_tree().root.get_node("Overworld/UIHolder/DialogueBox").get_node("RichTextLabel").text = get_node("KeyboardDisplay/Arrows").get_meta("Tooltip")
	elif Input.is_key_pressed(KEY_C):
		current_selected = "C"
		controls = "Keyboard"
		get_node("KeyboardDisplay/C").modulate.a = 1
		if get_tree().root.get_child(0).name == "MainMenu":
			get_tree().root.get_node("MainMenu/CanvasLayer/MarginContainer/DialogueBox").get_node("RichTextLabel").text = get_node("KeyboardDisplay/C").get_meta("Tooltip")
		else:
			get_tree().root.get_node("Overworld/UIHolder/DialogueBox").get_node("RichTextLabel").text = get_node("KeyboardDisplay/C").get_meta("Tooltip")
	elif Input.is_key_pressed(KEY_M):
		current_selected = "M"
		controls = "Keyboard"
		get_node("KeyboardDisplay/M").modulate.a = 1
		if get_tree().root.get_child(0).name == "MainMenu":
			get_tree().root.get_node("MainMenu/CanvasLayer/MarginContainer/DialogueBox").get_node("RichTextLabel").text = get_node("KeyboardDisplay/M").get_meta("Tooltip")
		else:
			get_tree().root.get_node("Overworld/UIHolder/DialogueBox").get_node("RichTextLabel").text = get_node("KeyboardDisplay/M").get_meta("Tooltip")
	elif Input.is_key_pressed(KEY_ESCAPE):
		current_selected = "Escape"
		controls = "Keyboard"
		get_node("KeyboardDisplay/Escape").modulate.a = 1
		if get_tree().root.get_child(0).name == "MainMenu":
			get_tree().root.get_node("MainMenu/CanvasLayer/MarginContainer/DialogueBox").get_node("RichTextLabel").text = get_node("KeyboardDisplay/Escape").get_meta("Tooltip")
		else:
			get_tree().root.get_node("Overworld/UIHolder/DialogueBox").get_node("RichTextLabel").text = get_node("KeyboardDisplay/Escape").get_meta("Tooltip")
	elif Input.is_key_pressed(KEY_X):
		get_node("KeyboardDisplay/X").modulate.a = 1
		current_selected = "X"
		controls = "Keyboard"
		if get_tree().root.get_child(0).name == "MainMenu":
			get_tree().root.get_node("MainMenu/CanvasLayer/MarginContainer/DialogueBox").get_node("RichTextLabel").text = get_node("KeyboardDisplay/X").get_meta("Tooltip")
		else:
			get_tree().root.get_node("Overworld/UIHolder/DialogueBox").get_node("RichTextLabel").text = get_node("KeyboardDisplay/X").get_meta("Tooltip")
	elif Input.is_key_pressed(KEY_SPACE):
		current_selected = "Space"
		controls = "Keyboard"
		get_node("KeyboardDisplay/Space").modulate.a = 1
		if get_tree().root.get_child(0).name == "MainMenu":
			get_tree().root.get_node("MainMenu/CanvasLayer/MarginContainer/DialogueBox").get_node("RichTextLabel").text = get_node("KeyboardDisplay/Space").get_meta("Tooltip")
		else:
			get_tree().root.get_node("Overworld/UIHolder/DialogueBox").get_node("RichTextLabel").text = get_node("KeyboardDisplay/Space").get_meta("Tooltip")
	elif Input.is_key_pressed(KEY_ENTER):
		current_selected = "Enter"
		controls = "Keyboard"
		get_node("KeyboardDisplay/Enter").modulate.a = 1
		if get_tree().root.get_child(0).name == "MainMenu":
			get_tree().root.get_node("MainMenu/CanvasLayer/MarginContainer/DialogueBox").get_node("RichTextLabel").text = get_node("KeyboardDisplay/Enter").get_meta("Tooltip")
		else:
			get_tree().root.get_node("Overworld/UIHolder/DialogueBox").get_node("RichTextLabel").text = get_node("KeyboardDisplay/Enter").get_meta("Tooltip")
	elif Input.is_key_pressed(KEY_W) || Input.is_key_pressed(KEY_A) || Input.is_key_pressed(KEY_S) || Input.is_key_pressed(KEY_D):
		current_selected = "WASD"
		controls = "Keyboard"
		get_node("KeyboardDisplay/WASD").modulate.a = 1
		if get_tree().root.get_child(0).name == "MainMenu":
			get_tree().root.get_node("MainMenu/CanvasLayer/MarginContainer/DialogueBox").get_node("RichTextLabel").text = get_node("KeyboardDisplay/WASD").get_meta("Tooltip")
		else:
			get_tree().root.get_node("Overworld/UIHolder/DialogueBox").get_node("RichTextLabel").text = get_node("KeyboardDisplay/WASD").get_meta("Tooltip")
	print(controls)
	pass

func use_controller():
	if Input.is_action_just_pressed("ui_left") || Input.is_action_just_pressed("ui_right") || Input.is_action_just_pressed("ui_down") || Input.is_action_just_pressed("ui_up"):
		get_node("ControllerDisplay/Analog_DPAD_Shoulders").modulate.a = 1
		current_selected = "Analog_DPAD_Shoulders"
		controls = "Controller"
		if get_tree().root.get_child(0).name == "MainMenu":
			get_tree().root.get_node("MainMenu/CanvasLayer/MarginContainer/DialogueBox").get_node("RichTextLabel").text = get_node("ControllerDisplay/Analog_DPAD_Shoulders").get_meta("Tooltip")
		else:
			get_tree().root.get_node("Overworld/UIHolder/DialogueBox").get_node("RichTextLabel").text = get_node("ControllerDisplay/Analog_DPAD_Shoulders").get_meta("Tooltip")
	elif Input.is_action_just_pressed("ui_select"):
		current_selected = "Triggers"
		controls = "Controller"
		get_node("ControllerDisplay/Triggers").modulate.a = 1
		if get_tree().root.get_child(0).name == "MainMenu":
			get_tree().root.get_node("MainMenu/CanvasLayer/MarginContainer/DialogueBox").get_node("RichTextLabel").text = get_node("ControllerDisplay/Triggers").get_meta("Tooltip")
		else:
			get_tree().root.get_node("Overworld/UIHolder/DialogueBox").get_node("RichTextLabel").text = get_node("ControllerDisplay/Triggers").get_meta("Tooltip")
	elif Input.is_action_just_pressed("ui_map"):
		current_selected = "Select"
		controls = "Controller"
		get_node("ControllerDisplay/Select").modulate.a = 1
		if get_tree().root.get_child(0).name == "MainMenu":
			get_tree().root.get_node("MainMenu/CanvasLayer/MarginContainer/DialogueBox").get_node("RichTextLabel").text = get_node("ControllerDisplay/Select").get_meta("Tooltip")
		else:
			get_tree().root.get_node("Overworld/UIHolder/DialogueBox").get_node("RichTextLabel").text = get_node("ControllerDisplay/Select").get_meta("Tooltip")
	elif Input.is_action_just_pressed("ui_menu"):
		current_selected = "Pause"
		controls = "Controller"
		get_node("ControllerDisplay/Pause").modulate.a = 1
		if get_tree().root.get_child(0).name == "MainMenu":
			get_tree().root.get_node("MainMenu/CanvasLayer/MarginContainer/DialogueBox").get_node("RichTextLabel").text = get_node("ControllerDisplay/Pause").get_meta("Tooltip")
		else:
			get_tree().root.get_node("Overworld/UIHolder/DialogueBox").get_node("RichTextLabel").text = get_node("ControllerDisplay/Pause").get_meta("Tooltip")
	elif Input.is_action_just_pressed("ui_cancel"):
		get_node("ControllerDisplay/TopFace").modulate.a = 1
		current_selected = "TopFace"
		controls = "Controller"
		if get_tree().root.get_child(0).name == "MainMenu":
			get_tree().root.get_node("MainMenu/CanvasLayer/MarginContainer/DialogueBox").get_node("RichTextLabel").text = get_node("ControllerDisplay/TopFace").get_meta("Tooltip")
		else:
			get_tree().root.get_node("Overworld/UIHolder/DialogueBox").get_node("RichTextLabel").text = get_node("ControllerDisplay/TopFace").get_meta("Tooltip")
	elif Input.is_action_just_pressed("ui_jump"):
		current_selected = "RightFace"
		controls = "Controller"
		get_node("ControllerDisplay/RightFace").modulate.a = 1
		if get_tree().root.get_child(0).name == "MainMenu":
			get_tree().root.get_node("MainMenu/CanvasLayer/MarginContainer/DialogueBox").get_node("RichTextLabel").text = get_node("ControllerDisplay/RightFace").get_meta("Tooltip")
		else:
			get_tree().root.get_node("Overworld/UIHolder/DialogueBox").get_node("RichTextLabel").text = get_node("ControllerDisplay/RightFace").get_meta("Tooltip")
	elif Input.is_action_just_pressed("ui_accept"):
		current_selected = "BottomFace"
		controls = "Controller"
		get_node("ControllerDisplay/BottomFace").modulate.a = 1
		if get_tree().root.get_child(0).name == "MainMenu":
			get_tree().root.get_node("MainMenu/CanvasLayer/MarginContainer/DialogueBox").get_node("RichTextLabel").text = get_node("ControllerDisplay/BottomFace").get_meta("Tooltip")
		else:
			get_tree().root.get_node("Overworld/UIHolder/DialogueBox").get_node("RichTextLabel").text = get_node("ControllerDisplay/BottomFace").get_meta("Tooltip")
	elif Input.is_action_just_pressed("camera_left") || Input.is_action_just_pressed("camera_right") || Input.is_action_just_pressed("camera_down") || Input.is_action_just_pressed("camera_up"):
		current_selected = "AnalogRight"
		controls = "Controller"
		get_node("ControllerDisplay/AnalogRight").modulate.a = 1
		if get_tree().root.get_child(0).name == "MainMenu":
			get_tree().root.get_node("MainMenu/CanvasLayer/MarginContainer/DialogueBox").get_node("RichTextLabel").text = get_node("ControllerDisplay/AnalogRight").get_meta("Tooltip")
		else:
			get_tree().root.get_node("Overworld/UIHolder/DialogueBox").get_node("RichTextLabel").text = get_node("ControllerDisplay/AnalogRight").get_meta("Tooltip")
	pass
