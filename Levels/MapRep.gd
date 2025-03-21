extends Sprite2D

@onready var player = %Player

# Called when the node enters the scene tree for the first time.
func _ready():
	set_up_map()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("ui_map") && !player.isInteracting && !player.jortTeleport:
		if !visible:
			visible = true
			%InteractiveMap.visible = true
			%AreaTitleCard.visible = false
			%TeleportMap.visible = false
			player.isInteracting = true
	elif Input.is_action_just_pressed("ui_map") && visible && !player.jortTeleport:
		visible = false
		%InteractiveMap.visible = false
		%AreaTitleCard.visible = true
		player.isInteracting = false
	if visible:
		set_up_map()
	pass

func set_up_map():
	#position = (repDistance * ((round(player.position) - (playerBoundary)) / playerDistance)) + repBoundary
	position.x = (556 * ((round(player.position.x) + 88) / 26960)) + 370
	position.x = round(position.x)
	
	position.y = ((716 * ((round(player.position.y) - 4880) / 34880)) + 722)
	position.y = round(position.y)
	get_child(0).text = str((round(player.position.y / -8) + 16)) + "  feet  from  sea  level"
	
	if %UserPrefsController.user_prefs.relaxed_checkname != "":
		for child in %InteractiveMap.get_children():
			if child.name == %UserPrefsController.user_prefs.relaxed_checkname && child.visible:
				child.modulate = Color(1, 1, 1, 1)
			elif child.name != %UserPrefsController.user_prefs.relaxed_checkname && child.visible:
				child.modulate = Color(.5, .5, .5, 1)
