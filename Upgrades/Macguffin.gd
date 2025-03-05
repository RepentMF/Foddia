extends Area2D

@onready var UI_keyboard = $UI_Keyboard
@onready var UI_controller = $UI_Controller
@onready var UI = $UI_Keyboard

var user_prefs: UserPreferences
var dialogue
var indexer = 0
var interacting = false
var isNearUpgrade = false
var temp_UI
var textCount = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	user_prefs = UserPreferences.load_or_create()
	dialogue = get_meta("DIALOGUE")
	textCount = dialogue.size()
	UI.visible = false
	change_colors()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if %Player.changeControls:
		change_icons()
	
	if user_prefs.relaxed_macguffin_flag && user_prefs.difficulty_dropdown_index == 0:
		queue_free()
	elif user_prefs.foddian_macguffin_flag && user_prefs.difficulty_dropdown_index == 1:
		queue_free()
	elif user_prefs.permadeath_macguffin_flag && user_prefs.difficulty_dropdown_index == 2:
		queue_free()
		
	if interacting && Input.is_action_just_released("ui_click"):
		if indexer == 0:
			%DialogueBox.visible = true
			%DialogueBox.get_node("RichTextLabel").text = dialogue[indexer]
			indexer += 1
		elif indexer < textCount:
			%DialogueBox.visible = true
			%DialogueBox.get_node("RichTextLabel").text = dialogue[indexer]
			indexer += 1
		elif indexer == textCount:
			indexer = 0
			%DialogueBox.visible = false
			interacting = false
			%Player.isInteracting = false
			%Player.hasMacguffin = true
			%QuickAudioPlayer.startPlaying = true
			%QuickAudioPlayer.reparent(get_tree().get_root())
			queue_free()
	elif !interacting && isNearUpgrade && Input.is_action_just_pressed("ui_click"):
		interacting = true
		%Player.isInteracting = true
		%DialogueBox.visible = true
		%DialogueBox.get_node("RichTextLabel").text = dialogue[indexer]
		UI.visible = false
	pass

func change_colors():
	if user_prefs.title_color_index == 0:
		UI_keyboard.modulate = Color(.945, .494, .095)
		UI_controller.modulate = Color(.945, .494, .095)
	elif user_prefs.title_color_index == 2:
		UI_keyboard.modulate = Color(1, .980, .267)
		UI_controller.modulate = Color(1, .980, .267)
	elif user_prefs.title_color_index == 3:
		UI_keyboard.modulate = Color(.059, .369, .969)
		UI_controller.modulate = Color(.059, .369, .969)
	elif user_prefs.title_color_index == 4:
		UI_keyboard.modulate = Color(.059, .655, .255)
		UI_controller.modulate = Color(.059, .655, .255)
	elif user_prefs.title_color_index == 5:
		UI_keyboard.modulate = Color(.937, .373, .902)
		UI_controller.modulate = Color(.937, .373, .902)
	pass

func change_icons():
	if %Player.currentMoveMethod == "Keyboard":
		UI = UI_keyboard
	elif %Player.currentMoveMethod == "Controller":
		UI = UI_controller
	pass

func _on_body_entered(body):
	if body.name == "Player":
		isNearUpgrade = true
		UI.visible = true
	pass # Replace with function body.

func _on_body_exited(body):
	if body.name == "Player":
		isNearUpgrade = false
		UI.visible = false
		UI_keyboard.visible = false
		UI_controller.visible = false
	pass # Replace with function body.
