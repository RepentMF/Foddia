extends Area2D

@onready var player = %Player
@onready var UI = $UI_Sprite2D

var user_prefs: UserPreferences
var dialogue
var indexer = 0
var interacting = false
var isNearSign = false
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
	if !visible && name == "Shadow"  && player.hasMacguffin2:
		visible = true
	elif name == "Husband" && player.hasMacguffin && player.hasMacguffin2:
		visible = false
	elif !visible && name == "Husband"  && player.hasMacguffin && !player.hasMacguffin2:
		visible = true
	
	if visible: 
		if !name.contains("Sign"):
			if player.hasMacguffin2:
				dialogue = get_meta("Dead")
				textCount = dialogue.size()
			elif player.hasMacguffin:
				dialogue = get_meta("Relieved")
				textCount = dialogue.size()
		
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
				_important_npc_check()
				UI.visible = true
		elif !interacting && isNearSign && Input.is_action_just_pressed("ui_click"):
			interacting = true
			%Player.isInteracting = true
			%DialogueBox.visible = true
			%DialogueBox.get_node("RichTextLabel").text = dialogue[indexer]
			UI.visible = false
	pass

func _important_npc_check():
	if name == "Husband":
		if get_node("anim").animation == "relieved":
			#get_tree().change_scene_to_file("res://Menus/DrivingEnding.tscn")
			print("Driving Ending")
	pass

func _on_body_entered(body):
	if body.name == "Player":
		isNearSign = true
		UI.visible = true
	pass # Replace with function body.

func _on_body_exited(body):
	if body.name == "Player":
		isNearSign = false
		UI.visible = false
	pass # Replace with function body.
