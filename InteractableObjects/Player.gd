extends CharacterBody2D

const MinSpeed = 100
const MaxSpeed = 400
const JetpackSpeed = 750
const RocketJumpSpeed = 250
const Up = Vector2(0, -1)

var countAirTime = 0
var countFallDistance = 0
var countJetpackFuel = 1000
var countRocketJumps = 2

var climbXValue = 0
var climbYValue = 0
var groundDirection = 0
var gravity = 300

var hasJetpack = false
var hasRocketJump = false
var hasReleasedRope = false

var isClimbingLedge = false
var isCrawlingLedge = false
var isFalling = false
var isGrabbingLedge = false
var isRunning = false
var isSwinging = false

var jumpSpeed = 100
var maxJetpackFuel = 1000
var maxRocketJumps = 2
var runSpeed = 100
var swingSpeed = 0
var swingRope = null
var wasJumping = false

#func _ready():
#	animatedSprite2D = $Sprite2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	#Handle death conditions
	#if !isDead || !hasReset:
		# Handle releasing a rope
		if hasReleasedRope:
			countAirTime += 1
			if countAirTime > 30:
				countAirTime = 0
				isSwinging = false
				hasReleasedRope = false
		# Handle swinging on a rope
		if isSwinging && swingRope != null:
			global_position = global_position.move_toward(Vector2(swingRope.global_position.x, swingRope.global_position.y), 10)
			if Input.is_action_just_pressed("ui_right"):
				swingRope.apply_impulse(Vector2(15, 0))
			elif Input.is_action_just_pressed("ui_left"):
				swingRope.apply_impulse(Vector2(-15, 0))
			elif Input.is_action_just_released("ui_cancel"):
				velocity = swingRope.linear_velocity
				swingRope = null
				hasReleasedRope = true
		# Handle climbing a ledge
		elif isGrabbingLedge:
			velocity.x = 0
			velocity.y = 0
			if isCrawlingLedge:
				crawl_ledge()
			elif isClimbingLedge:
				ascend_ledge()
			elif Input.is_action_pressed("ui_accept"):
				isClimbingLedge = true
				ascend_ledge()
		# Add the gravity, handle aerial movement and calculations
		elif !is_on_floor():
			velocity.y += gravity * delta
			isRunning = false
			groundDirection = sign(velocity.x)
			wasJumping = true
			if velocity.y > 400:
				isFalling = true
				countFallDistance += 1
				# Kill conidition still needs refinement
				if countFallDistance > 150 || velocity.y > 600:
					print("Player is kill")
			# Handle jetpack or rocket jumps
			if !isFalling:
				if hasJetpack:
					if Input.is_action_pressed("ui_accept") && countJetpackFuel > 0:
						countJetpackFuel -= 1
						if Input.is_action_pressed("ui_right"):
							velocity.x += 10
						elif Input.is_action_pressed("ui_left"):
							velocity.x += -10
						if Input.is_action_pressed("ui_up"):
							velocity.y += -10
						elif Input.is_action_pressed("ui_down"):
							velocity.y += 10
						elif !Input.is_action_pressed("ui_right") && !Input.is_action_pressed("ui_left"):
							velocity.y += -10
						else:
							velocity.y += -1
						if abs(velocity.x) > JetpackSpeed:
							velocity.x =  sign(velocity.x) * JetpackSpeed
						if abs(velocity.y) > JetpackSpeed:
							velocity.y = sign(velocity.y) * JetpackSpeed
				elif hasRocketJump:
					if Input.is_action_just_pressed("ui_accept") && countRocketJumps > 0:
						countRocketJumps -= 1
						if Input.is_action_pressed("ui_right"):
							if velocity.x > RocketJumpSpeed:
								velocity.x = velocity.x + RocketJumpSpeed
							else:
								velocity.x = RocketJumpSpeed
						elif Input.is_action_pressed("ui_left"):
							if velocity.x < -RocketJumpSpeed:
								velocity.x = velocity.x - RocketJumpSpeed
							else:
								velocity.x = -RocketJumpSpeed
						else:
							velocity.x = 0
						if Input.is_action_pressed("ui_up"):
							velocity.y = -RocketJumpSpeed
						elif Input.is_action_pressed("ui_down"):
							velocity.y = RocketJumpSpeed
						elif !Input.is_action_pressed("ui_right") && !Input.is_action_pressed("ui_left"):
							velocity.y = -RocketJumpSpeed
						else:
							velocity.y = -60
						if abs(velocity.x) == abs(velocity.y):
							velocity = velocity * 3 / 4
		# Handle grounded movement
		else:
			countFallDistance = 0
			countRocketJumps = maxRocketJumps
			isSwinging = false
			if isFalling:
				isFalling = false
			elif wasJumping:
				if groundDirection != sign(velocity.x):
					runSpeed = MinSpeed
					wasJumping = false
			# Enable running toggle
			if Input.is_action_pressed("ui_select"):
				isRunning = true
			elif Input.is_action_just_released("ui_select"):
				isRunning = false
			# Handle jumping
			if Input.is_action_just_pressed("ui_accept"):
				velocity.y = -jumpSpeed - (runSpeed * .25)
			# Handle moving left and right speeds
			if isRunning && runSpeed < MaxSpeed:
				runSpeed += 2.5
			elif !isRunning && runSpeed > MinSpeed:
				runSpeed -= 5
			if Input.is_action_just_pressed("ui_right"):
				runSpeed = MinSpeed
			elif Input.is_action_just_pressed("ui_left"):
				runSpeed = MinSpeed
			if Input.is_action_pressed("ui_right"):
				velocity.x = runSpeed
			elif Input.is_action_pressed("ui_left"):
				velocity.x = -runSpeed
			else:
				velocity.x = 0
				runSpeed = MinSpeed
		
		move_and_slide()
		
		# Apply initial force to rope
		#for n in get_slide_collision_count():
		#	var i = get_slide_collision(n)
		#	if i.get_collider() is RigidBody2D && i.get_collider().name.contains("RopeLinkage"):
		#		i.get_collider().apply_impulse(Vector2(0.25 * swingSpeed, 1))
		#		if Input.is_action_pressed("ui_cancel"):
		#			isSwinging = true
		#			swingRope = i.get_collider()
		if isSwinging && swingRope != null:
			swingSpeed = swingRope.linear_velocity.x
		else:
			swingSpeed = velocity.x
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
		runSpeed = MinSpeed

func use_hands(body):
	if body.name.contains("LedgeGrab"):
		if velocity.x != MaxSpeed:
			climbYValue = body.global_position.y + 1
			climbXValue = body.global_position.x
			isGrabbingLedge = true
			isFalling = false
		elif velocity.x == MaxSpeed:
			velocity.y = 0
			isFalling = true
	elif body.name.contains("Floor") && !isFalling:
		velocity.y = 0
		isFalling = true
	elif body.name.contains("RopeLinkage") && !isSwinging:
		print("yeah")
		body.apply_impulse(Vector2(0.5 * swingSpeed, 1))
		if Input.is_action_pressed("ui_cancel"):
			isSwinging = true
			swingRope = body
	
func _on_grab_area_2d_1_body_entered(body):
	use_hands(body)
	pass # Replace with function body.


func _on_grab_area_2d_2_body_entered(body):
	use_hands(body)
	pass # Replace with function body.
