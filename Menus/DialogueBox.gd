extends CanvasLayer

var user_prefs: UserPreferences

func _ready():
	user_prefs = UserPreferences.load_or_create()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_node("Node2D/DialogueBox").texture != get_meta("Boxes")[user_prefs.title_color_index]:
		get_node("Node2D/DialogueBox").texture = get_meta("Boxes")[user_prefs.title_color_index]
	pass
