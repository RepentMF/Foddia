extends Button

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	if get_tree().root.get_child(0).name == "MainMenu":
		text = "Back  to  Hike  Setup"
	else:
		text = "Back  to  thinking..."
	pass

func _on_pressed():
	if get_tree().root.get_child(0).name == "MainMenu":
		get_parent().visible = false
		get_tree().root.get_node("MainMenu/CanvasLayer/MarginContainer/DialogueBox").visible = false
		get_tree().root.get_node("MainMenu/CanvasLayer/MarginContainer/VBoxContainer").visible = true
		get_tree().root.get_node("MainMenu/CanvasLayer3").visible = true
		get_tree().root.get_node("MainMenu/Title").visible = true
		text = "Back  to  Hike  Setup"
		get_node("OptionSelect").play()
	else:
		get_parent().visible = false
		get_tree().root.get_child(0).get_node("UIHolder/DialogueBox").visible = false
		get_parent().get_parent().get_child(6).get_child(0).visible = true
		text = "Back  to  thinking..."
	pass # Replace with function body.
