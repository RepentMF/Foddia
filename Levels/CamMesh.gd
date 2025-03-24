extends Area2D

@onready var player = %Player

var addX = -1
var addY = -1
var breakAway = false
var camLocked = false
var isDead = false
var lockedPosition = Vector2(0, 0)
var minusX = -1
var minusY = -1
var temp_posX
var temp_posY
var initialPositionSet = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if !player.game_start:
		if !initialPositionSet:
			global_position = player.global_position
			temp_posX = global_position.x
			temp_posY = global_position.y
			initialPositionSet = true
		elif addX == -1:
			addX = 8
			addY = 8
			minusX = 8
			minusY = 8
		
		if isManualCamUsed() && !breakAway:
			camLocked = false
		elif !isManualCamUsed() && camLocked:
			global_position = player.global_position
		elif !(isManualCamUsed() && camLocked):
			global_position += (player.global_position - global_position).normalized() * 15
			temp_posX = global_position.x
			temp_posY = global_position.y
		
		if breakAway:
			global_position += (player.global_position - global_position).normalized() * 23
			temp_posX = global_position.x
			temp_posY = global_position.y
			if player.velocity.x == 0 && player.velocity.y == 0:
				breakAway = false
	pass

func oldCamMeshFunc():
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
	if !breakAway:
		if Input.is_action_pressed("camera_left") || Input.is_action_pressed("camera_right") || Input.is_action_pressed("camera_up") || Input.is_action_pressed("camera_down"):
			if Input.is_action_pressed("camera_left"):
				temp_posX = temp_posX - minusX
				global_position.x = temp_posX
			elif Input.is_action_pressed("camera_right"):
				temp_posX = temp_posX + addX
				global_position.x = temp_posX
			if Input.is_action_pressed("camera_up"):
				temp_posY = temp_posY - minusY
				global_position.y = temp_posY
			elif Input.is_action_pressed("camera_down"):
				temp_posY = temp_posY + addY
				global_position.y = temp_posY
			temp_posX = global_position.x
			temp_posY = global_position.y
			return true
		else:
			return false

func _on_area_entered(area):
	if initialPositionSet && addX != -1:
		if area.name == "CamCircle0":
			if !isManualCamUsed():
				global_position.x = round(player.global_position.x)
				global_position.y = round(player.global_position.y)
				camLocked = true
		elif area.name == "CamCircle3":
			minusX = 3
			addX = 3
			minusY = 3
			addY = 3
		elif area.name == "CamCircle2":
			minusX = 6
			addX = 6
			minusY = 6
			addY = 6
		elif area.name == "CamCircle1":
			minusX = 8
			addX = 8
			minusY = 8
			addY = 8
	pass

func _on_area_exited(area):
	if initialPositionSet:
		if area.name == "CamCircle4":
			breakAway = true
		elif area.name == "CamCircle3":
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
