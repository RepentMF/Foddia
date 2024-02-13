extends CharacterBody2D

var MinSpeed = 100
var MaxSpeed = 400
const Up = Vector2(0, -1)

var climbXValue = 0
var climbYValue = 0
var gravity = 300
var isClimbingLedge = false
var isCrawlingLedge = false
var isGrabbingLedge = false
var isRunning = false
var jumpVelocity = 100
var speed = 100

#func _ready():
#	animatedSprite2D = $Sprite2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	#Handle death conditions
	#if !isDead || !hasReset:
		# Handle climbing a ledge
		if isGrabbingLedge:
			velocity.x = 0
			velocity.y = 0
			if isCrawlingLedge:
				crawl_ledge()
			elif isClimbingLedge:
				ascend_ledge()
			elif Input.is_action_pressed("ui_accept"):
				isClimbingLedge = true
				ascend_ledge()
		# Add the gravity
		elif !is_on_floor():
			velocity.y += gravity * delta
			isRunning = false
		else:
			# Enable running toggle
			if Input.is_action_pressed("ui_cancel"):
				isRunning = true
			elif Input.is_action_just_released("ui_cancel"):
				isRunning = false
			# Handle jumping
			if Input.is_action_just_pressed("ui_accept"):
				velocity.y = -jumpVelocity - (speed * .2)
			# Handle moving left and right speeds
			if isRunning && speed < MaxSpeed:
				speed += 2.5
			elif !isRunning && speed > MinSpeed:
				speed -= 5
			if Input.is_action_just_pressed("ui_right"):
				speed = MinSpeed
			elif Input.is_action_just_pressed("ui_left"):
				speed = MinSpeed
			if Input.is_action_pressed("ui_right"):
				velocity.x = speed
			elif Input.is_action_pressed("ui_left"):
				velocity.x = -speed
			else:
				velocity.x = 0
				speed = MinSpeed
		
		move_and_slide()
		pass

func ascend_ledge():
	global_position = global_position.move_toward(Vector2(global_position.x, climbYValue), 1)
	if global_position.y == climbYValue:
		isCrawlingLedge = true
	pass
	
func crawl_ledge():
	global_position = global_position.move_toward(Vector2(climbXValue, global_position.y), 1)
	if global_position.x == climbXValue:
		isGrabbingLedge = false
		isClimbingLedge = false
		isCrawlingLedge = false
		speed = MinSpeed

func _on_grab_area_2d_1_body_entered(body):
	if body.name.contains("LedgeGrab"):
		climbYValue = body.global_position.y
		climbXValue = body.global_position.x
		isGrabbingLedge = true
		print("right")
	pass # Replace with function body.


func _on_grab_area_2d_2_body_entered(body):
	if body.name.contains("LedgeGrab"):
		climbYValue = body.global_position.y
		climbXValue = body.global_position.x
		isGrabbingLedge = true
		print("left")
	pass # Replace with function body.
