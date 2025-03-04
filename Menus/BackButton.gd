extends Button

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_pressed():
	get_parent().visible = false
	get_tree().root.get_node("MainMenu/CanvasLayer/MarginContainer/DialogueBox").visible = false
	get_tree().root.get_node("MainMenu/CanvasLayer/MarginContainer/VBoxContainer").visible = true
	get_tree().root.get_node("MainMenu/CanvasLayer3").visible = true
	get_tree().root.get_node("MainMenu/Title").visible = true
	pass # Replace with function body.
