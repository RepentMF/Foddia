extends TextureButton


var teleportSpot = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if get_parent().visible:
		if %UserPrefsController.user_prefs.teleportersAvailable:
			if name.contains("1") && %UserPrefsController.user_prefs.hasSong1:
				visible = true
			elif name.contains("2") && %UserPrefsController.user_prefs.hasSong2:
				visible = true
			elif name.contains("3") && %UserPrefsController.user_prefs.hasSong3:
				visible = true
			elif name.contains("4") && %UserPrefsController.user_prefs.hasSong4:
				visible = true
			elif name.contains("5") && %UserPrefsController.user_prefs.hasSong5:
				visible = true
			elif name.contains("6") && %UserPrefsController.user_prefs.hasSong6:
				visible = true
			elif name.contains("7") && %UserPrefsController.user_prefs.hasSong7:
				visible = true
			elif name.contains("8") && %UserPrefsController.user_prefs.hasSong8:
				visible = true
			else:
				visible = false
	else:
		visible = false
	pass
