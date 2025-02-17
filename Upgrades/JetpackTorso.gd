extends Area2D

@onready var UI_keyboard = $UI_Sprite2D
@onready var UI_controller = $UI_Sprite2D2

var user_prefs: UserPreferences
var controlsHaveChanged
var dialogue
var indexer = 0
var interacting = false
var isNearUpgrade = false
var temp_UI
var textCount = 0
var UI

# Called when the node enters the scene tree for the first time.
func _ready():
	user_prefs = UserPreferences.load_or_create()
	dialogue = get_meta("DIALOGUE")
	textCount = dialogue.size()
	UI.visible = false
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if controlsHaveChanged:
		change_icons()
	
	if user_prefs.relaxed_jetpack_flag && user_prefs.difficulty_dropdown_index == 0:
		queue_free()
	elif user_prefs.foddian_jetpack_flag && user_prefs.difficulty_dropdown_index == 1:
		queue_free()
	elif user_prefs.permadeath_jetpack_flag && user_prefs.difficulty_dropdown_index == 2:
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
			%Player.hasJetpack = true
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

func change_icons():
	if UI == UI_controller:
		UI = UI_keyboard
	elif UI == UI_keyboard:
		UI = UI_controller
	controlsHaveChanged = false
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
	pass # Replace with function body.
