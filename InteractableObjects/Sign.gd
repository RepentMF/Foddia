extends Area2D

@onready var player = %Player
@onready var UI_keyboard = $UI_Keyboard
@onready var UI_controller = $UI_Controller
@onready var UI = $UI_Keyboard

var endingCount = 0
var drivingEnding = false
var summitEnding = false

var user_prefs: UserPreferences
var dialogue
var dialogueCount = 0
var hasReadDialogue = false
var indexer = 0
var interacting = false
var isNearSign = false
var textCount = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	user_prefs = UserPreferences.load_or_create()
	dialogue = get_meta("DIALOGUE")
	dialogueCount = user_prefs.dialogue_count
	textCount = dialogue.size()
	UI.visible = false
	change_colors()
	
	if name.contains("BillBoard") || name.contains("Truck"):
		UI_keyboard.position.y = -80
		UI_controller.position.y = -100
		if !user_prefs.tooltips_bool_check && name.contains("BillBoard"):
			visible = false
	pass # Replace with function body.

func _physics_process(_delta):
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
			player.save_game()
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
			player.save_game()
			get_tree().change_scene_to_file("res://Menus/SummitEnding.tscn")
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if %Player.changeControls:
		change_icons()
	
	if !visible && name == "Shadow"  && player.hasMacguffin2:
		visible = true
		
	if name == "Husband" && player.hasMacguffin2:
		visible = false
	if !visible && name == "Husband" && (player.hasMacguffin || player.hasMacguffin3):
		visible = true
	
	if name == "TruckFront" && (player.hasMacguffin2 && !player.hasMacguffin && !player.hasMacguffin3):
		visible = false
	
	if visible:
		if name == "Husband" || name == "Shadow":
			if player.hasMacguffin2:
				dialogue = get_meta("Dead")
				textCount = dialogue.size()
			if player.hasMacguffin:
				dialogue = get_meta("Relieved")
				textCount = dialogue.size()
		elif name == "TruckFront":
			if player.hasMacguffin || player.hasMacguffin3:
				dialogue = get_meta("Relieved")
				textCount = dialogue.size()
		elif !name.contains("Sign") && !name.contains("Truck"):
			if player.hasMacguffin2:
				dialogue = get_meta("Dead")
				textCount = dialogue.size()
			if player.hasMacguffin:
				dialogue = get_meta("Relieved")
				textCount = dialogue.size()
		
		if interacting && Input.is_action_just_released("ui_click"):
			if indexer == 0:
				if name == "RMF":
					hasReadDialogue = false
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
			if name == "RMF":
				hasReadDialogue = true
				if dialogueCount < 6:
					if dialogueCount >= 1 && user_prefs.hasMP3:
						user_prefs.teleportersAvailable = true
						user_prefs.save()
					dialogueCount += 1
					user_prefs.dialogue_count = dialogueCount
					user_prefs.save()
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
	elif name == "RMF":
		if dialogueCount == 1 && %Player.hasMP3:
			dialogue = get_meta("Dialogue2")
			textCount = dialogue.size()
			get_node("RMF_dialogue").dialogue = get_node("RMF_dialogue").get_meta("Dialogue2")
		elif dialogueCount == 2:
			dialogue = get_meta("Dialogue3")
			textCount = dialogue.size()
			get_node("RMF_dialogue").dialogue = get_node("RMF_dialogue").get_meta("Dialogue3")
		elif dialogueCount == 3:
			dialogue = get_meta("Dialogue4")
			textCount = dialogue.size()
			get_node("RMF_dialogue").dialogue = get_node("RMF_dialogue").get_meta("Dialogue4")
		elif dialogueCount == 4:
			dialogue = get_meta("Dialogue5")
			textCount = dialogue.size()
			get_node("RMF_dialogue").dialogue = get_node("RMF_dialogue").get_meta("Dialogue5")
		elif dialogueCount == 5:
			dialogue = get_meta("Dialogue6")
			textCount = dialogue.size()
			get_node("RMF_dialogue").dialogue = get_node("RMF_dialogue").get_meta("Dialogue6")
		elif dialogueCount == 6:
			dialogue = get_meta("Repeat")
			textCount = dialogue.size()
			get_node("RMF_dialogue").dialogue = get_node("RMF_dialogue").get_meta("Repeat")
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
	if !name.contains("BillBoard"):
		if body.name == "Player":
			isNearSign = true
			UI.visible = true
	else:
		if user_prefs.tooltips_bool_check:
			if body.name == "Player":
				isNearSign = true
				UI.visible = true
	pass # Replace with function body.

func _on_body_exited(body):
	if !name.contains("BillBoard"):
		if body.name == "Player":
			isNearSign = false
			UI.visible = false
			UI_keyboard.visible = false
			UI_controller.visible = false
	else:
		if user_prefs.tooltips_bool_check:
			if body.name == "Player":
				isNearSign = false
				UI.visible = false
				UI_keyboard.visible = false
				UI_controller.visible = false
	pass # Replace with function body.
