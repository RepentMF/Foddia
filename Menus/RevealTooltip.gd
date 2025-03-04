extends TextureButton

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_focus_entered():
	get_parent().modulate.a = 1
	get_tree().root.get_node("MainMenu/CanvasLayer/MarginContainer/DialogueBox").get_node("RichTextLabel").text = get_parent().get_meta("Tooltip")
	pass # Replace with function body.

func _on_focus_exited():
	get_parent().modulate.a = 0
	get_tree().root.get_node("MainMenu/CanvasLayer/MarginContainer/DialogueBox").get_node("RichTextLabel").text = ""
	pass # Replace with function body.

func _on_mouse_entered():
	get_parent().modulate.a = 1
	get_tree().root.get_node("MainMenu/CanvasLayer/MarginContainer/DialogueBox").get_node("RichTextLabel").text = get_parent().get_meta("Tooltip")
	pass # Replace with function body.

func _on_mouse_exited():
	get_parent().modulate.a = 0
	get_tree().root.get_node("MainMenu/CanvasLayer/MarginContainer/DialogueBox").get_node("RichTextLabel").text = ""
	pass # Replace with function body.

func _on_pressed():
	if get_parent().get_node("ControllerDisplay").visible:
		get_parent().get_node("KeyboardDisplay").visible = true
		get_parent().get_node("ControllerDisplay").visible = false
	elif get_parent().get_node("KeyboardDisplay").visible:
		get_parent().get_node("KeyboardDisplay").visible = false
		get_parent().get_node("ControllerDisplay").visible = true
	pass # Replace with function body.
