extends Area2D

@onready var player = %Player

var addX = 5
var addY = 5
var breakAway = false
var camLocked = false
var isDead = false
var lockedPosition = Vector2(0, 0)
var minusX = 5
var minusY = 5
var initialPositionSet = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if !initialPositionSet:
		camLocked = true
		initialPositionSet = true
		lockedPosition = player.position - Vector2(337, -95)
		position = lockedPosition
		#position = position.round()
	
	if !player.game_start && !player.isInteracting:
		if isDead:
			camLocked = true
			lockedPosition = player.position - Vector2(337, -95)
			position = lockedPosition
			#position = position.round()
			isDead = false
		else:
			lockedPosition = player.position - Vector2(337, -95)
			if Input.is_action_pressed("camera_left") && position.x > lockedPosition.x - 321 && !breakAway:
				camLocked = false
				position.x -= minusX
			elif Input.is_action_pressed("camera_right") && position.x < lockedPosition.x + 321 && !breakAway:
				camLocked = false
				position.x += addX
			elif camLocked && !breakAway:
				position = lockedPosition
			elif (!isManualCamUsed() && !camLocked) || breakAway:
				var tempVar = 40
				var tempSpeed = tempVar * (player.position - Vector2(337, -95) - position).normalized()
				position.x = position.x + tempSpeed.x
			
			if Input.is_action_pressed("camera_up") && position.y > lockedPosition.y - 321 && !breakAway:
				camLocked = false
				position.y -= minusY
			elif Input.is_action_pressed("camera_down") && position.y < lockedPosition.y + 321 && !breakAway:
				camLocked = false
				position.y += addY
			elif camLocked && !breakAway:
				position = lockedPosition
			elif (!isManualCamUsed() && !camLocked) || breakAway:
				var tempVar = 40
				if player.isFreefalling && player.velocity.y > 400:
					tempVar = 70
				var tempSpeed = tempVar * (player.position - Vector2(337, -95) - position).normalized()
				position.y = position.y + tempSpeed.y
			
			if abs(player.position.x - 337 - position.x) >= 500 || abs(player.position.y + 95 - position.y) >= 500 || (player.isFreefalling && player.velocity.y > 400):
				breakAway = true
	pass

func isManualCamUsed():
	if !camLocked && Input.is_action_pressed("camera_left") || Input.is_action_pressed("camera_right") || Input.is_action_pressed("camera_up") || Input.is_action_pressed("camera_down"):
		return true
	else:
		return false

func _on_area_entered(area):
	if area.name == "CamCircle1":
		minusX = 8
		addX = 8
		minusY = 8
		addY = 8
	elif area.get_parent().name == "Player" && !area.name.contains("CamCircle"):
		camLocked = true
		breakAway = false
	pass

func _on_area_exited(area):
	if area.name == "CamCircle3":
		minusX = 0
		addX = 0
		minusY = 0
		addY = 0
	elif area.name == "CamCircle2":
		minusX = 3
		addX = 3
		minusY = 3
		addY = 3
	elif area.name == "CamCircle1":
		minusX = 6
		addX = 6
		minusY = 6
		addY = 6
	pass # Replace with function body.
