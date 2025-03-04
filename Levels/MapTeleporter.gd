extends TextureButton

var user_prefs: UserPreferences

var teleportSpot = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	user_prefs = UserPreferences.load_or_create()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_parent().visible:
		if user_prefs.teleportersAvailable:
			if name.contains("1") && user_prefs.hasSong1:
				visible = true
			elif name.contains("2") && user_prefs.hasSong2:
				visible = true
			elif name.contains("3") && user_prefs.hasSong3:
				visible = true
			elif name.contains("4") && user_prefs.hasSong4:
				visible = true
			elif name.contains("5") && user_prefs.hasSong5:
				visible = true
			elif name.contains("6") && user_prefs.hasSong6:
				visible = true
			elif name.contains("7") && user_prefs.hasSong7:
				visible = true
			elif name.contains("8") && user_prefs.hasSong8:
				visible = true
			else:
				visible = false
	else:
		visible = false
	pass
