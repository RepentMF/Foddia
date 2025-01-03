extends Area2D

@onready var UI = $UI_Sprite2D

var user_prefs: UserPreferences
var dialogue
var indexer = 0
var interacting = false
var isNearUpgrade = false
var textCount = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	user_prefs = UserPreferences.load_or_create()
	dialogue = get_meta("DIALOGUE")
	textCount = dialogue.size()
	UI.visible = false
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if user_prefs.relaxed_macguffin2_flag && user_prefs.difficulty_dropdown_index == 0:
		queue_free()
	elif user_prefs.foddian_macguffin2_flag && user_prefs.difficulty_dropdown_index == 1:
		queue_free()
	elif user_prefs.permadeath_macguffin2_flag && user_prefs.difficulty_dropdown_index == 2:
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
			%Player.hasMacguffin2 = true
			queue_free()
	elif !interacting && isNearUpgrade && Input.is_action_just_pressed("ui_click"):
		interacting = true
		%Player.isInteracting = true
		%DialogueBox.visible = true
		%DialogueBox.get_node("RichTextLabel").text = dialogue[indexer]
		UI.visible = false
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
