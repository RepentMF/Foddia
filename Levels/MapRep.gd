extends Sprite2D

@onready var player = %Player

# Called when the node enters the scene tree for the first time.
func _ready():
	determine_position()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_map") && !player.isInteracting:
		if !visible:
			visible = true
			%InteractiveMap.visible = true
			%AreaTitleCard.visible = false
			player.isInteracting = true
	elif Input.is_action_just_pressed("ui_map") && visible:
		visible = false
		%InteractiveMap.visible = false
		%AreaTitleCard.visible = true
		player.isInteracting = false
	
	if visible:
		determine_position()
	pass

func determine_position():
	#position = (repDistance * ((round(player.position) - (playerBoundary)) / playerDistance)) + repBoundary
	position.x = (556 * ((round(player.position.x) + 88) / 26960)) + 370
	position.x = round(position.x)
	
	position.y = ((716 * ((round(player.position.y) - 4880) / 34880)) + 722)
	position.y = round(position.y)
