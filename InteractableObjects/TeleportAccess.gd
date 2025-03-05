extends Area2D

@onready var player = %Player
@onready var UI_keyboard = $UI_Keyboard
@onready var UI_controller = $UI_Controller
@onready var UI_M = $UI_M
@onready var UI_Select = $UI_Select
@onready var UI = $UI_Keyboard

var user_prefs: UserPreferences
var areaName = ""
var fadeInCount = 75
var finished = false
var finishedCount = 20
var interacting = false
var isNearTeleport = false
var isReady = false
var originalColor
var teleportSpot = Vector2(24116, -3688)
var useable = false

# Called when the node enters the scene tree for the first time.
func _ready():
	user_prefs = UserPreferences.load_or_create()
	UI.visible = false
	change_colors()
	pass # Replace with function body.

func _physics_process(_delta):
	if user_prefs.teleportersAvailable && user_prefs.dialogue_count > 0:
		if name.contains("0"):
			useable = true
			visible = true
		if name.contains("1") && user_prefs.hasSong1:
			useable = true
			visible = true
		elif name.contains("2") && user_prefs.hasSong2:
			useable = true
			visible = true
		elif name.contains("3") && user_prefs.hasSong3:
			useable = true
			visible = true
		elif name.contains("4") && user_prefs.hasSong4:
			useable = true
			visible = true
		elif name.contains("5") && user_prefs.hasSong5:
			useable = true
			visible = true
		elif name.contains("6") && user_prefs.hasSong6:
			useable = true
			visible = true
		elif name.contains("7") && user_prefs.hasSong7:
			useable = true
			visible = true
		elif name.contains("8") && user_prefs.hasSong8:
			useable = true
			visible = true
	else:
		visible = false
		useable = false
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	areaName = player.areaName
	if %Player.changeControls:
		change_icons()
	
	if isReady:
		%InteractiveMap.visible = false
		%TeleportMap.visible = false
		%MapPlayerRep.visible = false
	
	if name == "TeleportAccess0" && !isReady:
		if isNearTeleport && Input.is_action_just_pressed("ui_map") && !interacting:
			interacting = true
			%InteractiveMap.visible = true
			%TeleportMap.visible = true
		elif isNearTeleport && Input.is_action_just_pressed("ui_map") && interacting:
			interacting = false
			%InteractiveMap.visible = false
			%TeleportMap.visible = false
	elif name != "TeleportAccess0" || (name == "TeleportAccess0" && isReady):
		if finished:
			finishedCount -= 1
			if finishedCount == 10:
				player.isInteracting = false
				%RadioPlayer.itemIsPlaying = false
				interacting = false
			elif finishedCount <= 0:
				%FadeInPanel.color = originalColor
				%FadeInPanel.visible = false
				fadeInCount = 75
				finishedCount = 20
				finished = false
				isReady = false
				teleportSpot = Vector2(24112, -3688)
		
		if isNearTeleport && Input.is_action_just_released("ui_click") && areaName != "107.9 The Jort":
			if useable:
				interacting = true
		
		if interacting:
			player.isInteracting = true
			%RadioPlayer.itemIsPlaying = true
			if fadeInCount == 75:
				get_node("Teleport").play()
				originalColor = %FadeInPanel.color
				%FadeInPanel.visible = true
				%FadeInPanel.color = Color(0, 1, 0, .5)
				fadeInCount -= 1
			elif fadeInCount > 0:
				fadeInCount -= 1
				%FadeInPanel.visible = true
				if fadeInCount >= 45:
					%FadeInPanel.color = Color(0, 1, .1, .7)
				elif fadeInCount >= 40:
					%FadeInPanel.color = Color(0, 1, .12, .8)
				elif fadeInCount >= 10:
					%FadeInPanel.color = Color(0, 1, .15, 1)
					player.global_position = teleportSpot
				elif fadeInCount < 10 && fadeInCount >= 5:
					%FadeInPanel.color = Color(1, 1, 1, 1)
				elif fadeInCount < 5:
					%FadeInPanel.color = Color(0, 0, 0, 1)
	pass

func change_colors():
	if user_prefs.title_color_index == 0:
		UI_keyboard.modulate = Color(.945, .494, .095)
		UI_controller.modulate = Color(.945, .494, .095)
		UI_M.modulate = Color(.945, .494, .095)
		UI_Select.modulate = Color(.945, .494, .095)
	elif user_prefs.title_color_index == 2:
		UI_keyboard.modulate = Color(1, .980, .267)
		UI_controller.modulate = Color(1, .980, .267)
		UI_M.modulate = Color(1, .980, .267)
		UI_Select.modulate = Color(1, .980, .267)
	elif user_prefs.title_color_index == 3:
		UI_keyboard.modulate = Color(.059, .369, .969)
		UI_controller.modulate = Color(.059, .369, .969)
		UI_M.modulate = Color(.059, .369, .969)
		UI_Select.modulate = Color(.059, .369, .969)
	elif user_prefs.title_color_index == 4:
		UI_keyboard.modulate = Color(.059, .655, .255)
		UI_controller.modulate = Color(.059, .655, .255)
		UI_M.modulate = Color(.059, .655, .255)
		UI_Select.modulate = Color(.059, .655, .255)
	elif user_prefs.title_color_index == 5:
		UI_keyboard.modulate = Color(.937, .373, .902)
		UI_controller.modulate = Color(.937, .373, .902)
		UI_M.modulate = Color(.937, .373, .902)
		UI_Select.modulate = Color(.937, .373, .902)
	pass

func change_icons():
	if %Player.currentMoveMethod == "Keyboard":
		UI = UI_keyboard
		if name == "TeleportAccess0":
			UI = UI_M
	elif %Player.currentMoveMethod == "Controller":
		UI = UI_controller
		if name == "TeleportAccess0":
			UI = UI_Select
	pass

func _on_body_entered(body):
	isNearTeleport = true
	UI.visible = true
	pass # Replace with function body.

func _on_body_exited(body):
	isNearTeleport = false
	UI.visible = false
	UI_keyboard.visible = false
	UI_controller.visible = false
	pass # Replace with function body.

func _on_teleport_finished():
	finished = true
	pass # Replace with function body.

func _on_teleporter1_pressed():
	teleportSpot = Vector2(6002, -203)
	isReady = true
	pass # Replace with function body.

func _on_teleporter2_pressed():
	teleportSpot = Vector2(20389, -3307)
	isReady = true
	pass # Replace with function body.

func _on_teleporter3_pressed():
	teleportSpot = Vector2(10293, -6105)
	isReady = true
	pass # Replace with function body.

func _on_teleporter4_pressed():
	teleportSpot = Vector2(19232, -9546)
	isReady = true
	pass # Replace with function body.

func _on_teleporter5_pressed():
	teleportSpot = Vector2(16176, -18809)
	isReady = true
	pass # Replace with function body.

func _on_teleporter6_pressed():
	teleportSpot = Vector2(26784, -1751)
	isReady = true
	pass # Replace with function body.

func _on_teleporter7_pressed():
	teleportSpot = Vector2(24152, -4196)
	isReady = true
	pass # Replace with function body.

func _on_teleporter8_pressed():
	teleportSpot = Vector2(22856, 2024)
	isReady = true
	pass # Replace with function body.
