extends Button

var tooltip
var tooltip_txt

# Called when the node enters the scene tree for the first time.
func _ready():
	tooltip_txt = get_meta("Tooltip")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if get_node("OptionSelect") != null:
		get_node("OptionSelect").volume_db = %SFXVolumeHandler.SFX_volume
	if %UserPrefsController.user_prefs.tooltips_bool_check:
		tooltip = true
	else:
		tooltip = false
	pass
	
func _on_mouse_entered():
	if get_tree().root.get_node("MainMenu") != null:
		get_tree().root.get_node("MainMenu").cursor_highlighted = -101
	if tooltip && !%Credits.visible:
		%DialogueBox.get_node("RichTextLabel").text = tooltip_txt
		%DialogueBox.visible = true
		%MainMenuBg.texture = %MainMenuLookingBg.texture
	pass # Replace with function body.

func _on_mouse_exited():
	if tooltip && !%Credits.visible:
		%DialogueBox.get_node("RichTextLabel").text = tooltip_txt
		%DialogueBox.visible = false
		%MainMenuBg.texture = %MainMenuNotLookingBg.texture
	pass # Replace with function body.

func _on_button_up():
	get_node("OptionSelect").play()
	pass # Replace with function body.
