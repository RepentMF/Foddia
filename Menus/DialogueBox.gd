extends CanvasLayer

@onready var UI_keyboard = $UI_Keyboard
@onready var UI_controller = $UI_Controller
@onready var UI = $UI_Keyboard

var user_prefs: UserPreferences

func _ready():
	user_prefs = UserPreferences.load_or_create()
	change_colors()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_parent().get_parent().name == "Overworld":
		if %Player.changeControls:
			change_icons()
			UI.visible = true
	
	if get_node("Node2D/DialogueBox").texture != get_meta("Boxes")[user_prefs.title_color_index]:
		get_node("Node2D/DialogueBox").texture = get_meta("Boxes")[user_prefs.title_color_index]
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
	if %Player.currentMoveMethod == "Keyboard" || %Player.currentConfirmMethod == "Keyboard":
		UI = UI_keyboard
		UI_keyboard.visible = true
		UI_controller.visible = false
	elif %Player.currentMoveMethod == "Controller" || %Player.currentConfirmMethod == "Controller":
		UI = UI_controller
		UI_keyboard.visible = false
		UI_controller.visible = true
	UI.visible = true
	pass
