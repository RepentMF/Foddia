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
	if user_prefs.hasSong1 && name == "MP3_1":
		queue_free()
	elif user_prefs.hasSong2 && name == "MP3_2":
		queue_free()
		%TeleportAccess2.visible = true
		%TeleportAccess2.useable = true
	elif user_prefs.hasSong3 && name == "MP3_3":
		queue_free()
		%TeleportAccess3.visible = true
		%TeleportAccess3.useable = true
	elif user_prefs.hasSong4 && name == "MP3_4":
		queue_free()
		%TeleportAccess4.visible = true
		%TeleportAccess4.useable = true
	elif user_prefs.hasSong5 && name == "MP3_5":
		queue_free()
		%TeleportAccess5.visible = true
		%TeleportAccess5.useable = true
	elif user_prefs.hasSong6 && name == "MP3_6":
		queue_free()
		%TeleportAccess6.visible = true
		%TeleportAccess6.useable = true
	elif user_prefs.hasSong7 && name == "MP3_7":
		queue_free()
		%TeleportAccess7.visible = true
		%TeleportAccess7.useable = true
	elif user_prefs.hasSong8 && name == "MP3_8":
		queue_free()
		%TeleportAccess8.visible = true
		%TeleportAccess8.useable = true
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if %Player.changeControls:
		change_icons()
	
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
			%QuickAudioPlayer.startPlaying = true
			%QuickAudioPlayer.reparent(get_tree().get_root())
			queue_free()
	elif !interacting && isNearUpgrade && Input.is_action_just_pressed("ui_click"):
		interacting = true
		%Player.isInteracting = true
		%DialogueBox.visible = true
		%DialogueBox.get_node("RichTextLabel").text = dialogue[indexer]
		UI.visible = false
		%Player.hasMP3 = true
		user_prefs.hasMP3 = true
		if name == "MP3_1":
			user_prefs.hasSong1 = true
		elif name == "MP3_2":
			user_prefs.hasSong2 = true
		if name == "MP3_3":
			user_prefs.hasSong3 = true
		elif name == "MP3_4":
			user_prefs.hasSong4 = true
		elif name == "MP3_5":
			user_prefs.hasSong5 = true
		elif name == "MP3_6":
			user_prefs.hasSong6 = true
		if name == "MP3_7":
			user_prefs.hasSong7 = true
		elif name == "MP3_8":
			user_prefs.hasSong8 = true
		user_prefs.save()
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

func _on_area_entered(area):
	if area.name.contains("Reveal"):
		get_node("PointLight2D").visible = false
	pass # Replace with function body.

func _on_area_exited(area):
	if area.name.contains("Reveal"):
		get_node("PointLight2D").visible = true
	pass # Replace with function body.
