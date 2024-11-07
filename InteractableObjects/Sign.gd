extends Area2D

@onready var player = %Player
@onready var UI = $UI_Sprite2D

var endingCount = 0
var drivingEnding = false
var summitEnding = false

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

func _physics_process(delta):
	if drivingEnding:
		%FadeInPanel.visible = true
		if endingCount == 0:
			%FadeInPanel.color = Color(0, 0, 0, 0)
		if endingCount % 10 == 0 && %FadeInPanel.color.a < 1:
			endingCount += 1
			%FadeInPanel.color.a += .1
		elif %FadeInPanel.color.a < 1:
			endingCount += 1
		elif %FadeInPanel.color.a >= 1:
			get_tree().change_scene_to_file("res://Menus/DrivingEnding.tscn")
	elif summitEnding:
		%FadeInPanel.visible = true
		if endingCount == 0:
			%FadeInPanel.color = Color(0, 0, 0, 0)
		if endingCount % 10 == 0 && %FadeInPanel.color.a < 1:
			endingCount += 1
			%FadeInPanel.color.a += .1
		elif %FadeInPanel.color.a < 1:
			endingCount += 1
		elif %FadeInPanel.color.a >= 1:
			get_tree().change_scene_to_file("res://Menus/SummitEnding.tscn")
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !visible && name == "Shadow"  && player.hasMacguffin2:
		visible = true
		
	if name == "Husband" && player.hasMacguffin2:
		visible = false
	if !visible && name == "Husband" && (player.hasMacguffin || player.hasMacguffin3):
		print(visible, " ", name, " ", player.hasMacguffin, " ", player.hasMacguffin3)
		visible = true
	
	if name == "TruckFront" && (player.hasMacguffin2 && !player.hasMacguffin && !player.hasMacguffin3):
		visible = false
	
	if visible: 
		if !name.contains("Sign") && !name.contains("Truck"):
			if player.hasMacguffin2:
				dialogue = get_meta("Dead")
				textCount = dialogue.size()
			if player.hasMacguffin || player.hasMacguffin3:
				dialogue = get_meta("Relieved")
				textCount = dialogue.size()
		elif name == "TruckFront":
			if player.hasMacguffin || player.hasMacguffin3:
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
	if name == "TruckFront" && (player.hasMacguffin || player.hasMacguffin3):
		drivingEnding = true
		%Player.anEnding = true
		%Player.isInteracting = false
	elif name == "Shadow":
		if get_node("anim").animation == "dead":
			player.badEnding = true
			player.isDead = true
			%Player.get_node("AudioPlayer/DeadLanded").play(0)
	elif name == "SummitEnding":
		summitEnding = true
		%Player.anEnding = true
		%Player.isInteracting = false
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
