extends CharacterBody2D

const ElevationLow = 0
const ElevationHigh = 30000
const JetpackSpeed = 750
const RocketJumpSpeed = 250
const Up = Vector2(0, -1)

var count = 0
var countAirTime = 0
var countFallDistance = 0
var countJetpackFuel = 1000
var countRocketJumps = 2

var climbXValue = 0
var climbYValue = 0
var groundDirection = 0
var gravity = 300
var gravityLight = 100
var gravityStandard = 300

var hasJetpack = false
var hasRocketJump = false
var hasReleasedRope = false

var isClimbingLedge = false
var isCrawlingLedge = false
var isDead = false
var isFreefalling = false
var isGrabbingLedge = false
var isInWindCurrent = false
var isNearRope = false
var isOnIce = false
var isRunning = false
var isSwinging = false

var jumpSpeed = 100
var jumpSpeedStandard = 100
var maxJetpackFuel = 1000
var maxIceRunSpeed = 600
var maxRocketJumps = 2
var maxRunSpeed = 350
var minRunSpeed = 100
var runSpeed = 100
var swingSpeed = 0
var swingRope = null
var ropeBottom
var ropeTempPosition = 0
var ropeTop
var wasBouncing = false
var wasJumping = false

#func _ready():
#	animatedSprite2D = $Sprite2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if swingRope != null:
		if isSwinging && swingRope.get_parent().name.contains("Swinging"):
			rotation = swingRope.rotation
	else:
		rotation = 0
	pass

func _physics_process(delta):
	#Handle death conditions
	#if !isDead || !hasReset:
		if isDead:
			print("Player is kill")
		jumpSpeed = jumpSpeedStandard - ((abs(global_position.y) / ElevationHigh) * 20)
		# Handle grabbing rope
		if Input.is_action_pressed("ui_cancel") && isNearRope:
			isSwinging = true
		elif Input.is_action_just_released("ui_cancel"):
			hasReleasedRope = true
		# Handle releasing rope
		if hasReleasedRope:
			countAirTime += 1
			if countAirTime > 15:
				countAirTime = 0
				isSwinging = false
				hasReleasedRope = false
				isNearRope = false
				swingRope = null
				wasBouncing = false
				ropeTempPosition = 0
		# Handle physics on a rope
		if !hasRocketJump && !hasJetpack && swingRope != null && isSwinging:
			if isSwinging && swingRope.get_parent().name.contains("Swinging"):
				global_position = Vector2(swingRope.global_position.x, swingRope.global_position.y)
				if Input.is_action_just_pressed("ui_right"):
					swingRope.apply_impulse(Vector2(15, 0))
				elif Input.is_action_just_pressed("ui_left"):
					swingRope.apply_impulse(Vector2(-15, 0))
				elif hasReleasedRope:
					if swingRope.name.contains("Bottom") || swingRope.name.contains("10") || swingRope.name.contains("9") || swingRope.name.contains("8") || swingRope.name.contains("7"):
						velocity = ropeBottom.linear_velocity
						swingRope = null
					else:
						velocity = ropeBottom.linear_velocity / 2
						swingRope = null
			elif isSwinging && swingRope.get_parent().name.contains("Static"):
				global_position = global_position.move_toward(Vector2(swingRope.global_position.x, ropeTempPosition.y), 10)
				if global_position.y > ropeBottom.global_position.y + 20 || global_position.y < ropeTop.global_position.y - 26 || Input.is_action_just_released("ui_cancel"):
					velocity = swingRope.linear_velocity
					hasReleasedRope = true
				elif Input.is_action_pressed("ui_up"):
					global_position.y = ropeTempPosition.y - 2
					ropeTempPosition.y = global_position.y
					if global_position.y < ropeTop.global_position.y - 26:
						global_position.y = ropeTop.global_position.y - 26
						ropeTempPosition.y = ropeTop.global_position.y - 26
						velocity.x = 0
						runSpeed = minRunSpeed
				elif Input.is_action_pressed("ui_down"):
					global_position.y = ropeTempPosition.y + 2
					ropeTempPosition.y = global_position.y
					if global_position.y > ropeBottom.global_position.y + 20:
						hasReleasedRope = true
						countAirTime = 10
		# Handle climbing a ledge
		elif !hasRocketJump && !hasJetpack && isGrabbingLedge:
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
			if isInWindCurrent:
				gravity = gravityLight
			else:
				gravity = gravityStandard
			velocity.y += gravity * delta
			isRunning = false
			groundDirection = sign(velocity.x)
			wasJumping = true
			if velocity.y > 400:
				isFreefalling = true
				countFallDistance += 1
				# Kill conidition still needs refinement
				if countFallDistance > 180 || velocity.y > 600:
					print(countFallDistance, " ", velocity.y)
					isDead = true
			# Handle jetpack or rocket jumps
			if !isFreefalling:
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
			if isFreefalling:
				isFreefalling = false
			elif wasJumping:
				if groundDirection != sign(velocity.x):
					runSpeed = minRunSpeed
					wasJumping = false
			if isOnIce:
				# Enable running toggle
				if Input.is_action_pressed("ui_select"):
					isRunning = true
				elif Input.is_action_just_released("ui_select"):
					isRunning = false
				# Handle moving left and right speeds
				if Input.is_action_pressed("ui_right"):
					if isRunning:
						velocity.x += 4
					else:
						velocity.x += 2
				elif Input.is_action_pressed("ui_left"):
					if isRunning:
						velocity.x += -4
					else:
						velocity.x += -2
				if abs(velocity.x) > maxIceRunSpeed:
					velocity.x = maxIceRunSpeed * sign(velocity.x)
				# Handle jumping
				if Input.is_action_just_pressed("ui_accept"):
					velocity.y = -jumpSpeed - (abs(velocity.x) * .25)
			else:
				# Enable running toggle
				if Input.is_action_pressed("ui_select"):
					isRunning = true
				elif Input.is_action_just_released("ui_select"):
					isRunning = false
				# Handle jumping
				if Input.is_action_just_pressed("ui_accept"):
					velocity.y = -jumpSpeed - (runSpeed * .25)
				# Handle moving left and right speeds
				if isRunning && runSpeed < maxRunSpeed:
					runSpeed += 1.5
				elif !isRunning && runSpeed > minRunSpeed:
					runSpeed -= 4
				if Input.is_action_just_pressed("ui_right"):
					runSpeed = minRunSpeed
				elif Input.is_action_just_pressed("ui_left"):
					runSpeed = minRunSpeed
				if !wasBouncing:
					if Input.is_action_pressed("ui_right"):
						velocity.x = runSpeed
					elif Input.is_action_pressed("ui_left"):
						velocity.x = -runSpeed
					else:
						velocity.x = 0
						runSpeed = minRunSpeed
				elif count > 0:
					wasBouncing = false
				elif count == 0:
					count +=1
		
		move_and_slide()
		
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
		runSpeed = minRunSpeed

func use_hands(body):
	if body.name.contains("LedgeGrab"):
		if velocity.x != maxRunSpeed:
			climbYValue = body.global_position.y + 1
			climbXValue = body.global_position.x
			isGrabbingLedge = true
			isFreefalling = false
		elif velocity.x == maxRunSpeed:
			velocity.y = 0
			isFreefalling = true
	elif (body.name.contains("Floor") || body.name.contains("Wall")) && !isFreefalling:
		if abs(velocity.x) > 525:
			isDead = true
		isFreefalling = true
	elif body.name.contains("RopeLinkage") && swingRope == null:
		isNearRope = true
		if !isSwinging:
			body.apply_impulse(Vector2(0.5 * swingSpeed, 1))
			swingRope = body
			ropeTempPosition = global_position
			ropeBottom = body.get_parent().get_node("RopeLinkageBottom")
			ropeTop = body.get_parent().get_node("RopeLinkageTop")

func use_legs(body):
	if body.name.contains("RopeLinkage") && swingRope == null:
		isNearRope = true
		if !isSwinging:
			body.apply_impulse(Vector2(0.5 * swingSpeed, 1))
			swingRope = body
			ropeTempPosition = global_position
			ropeBottom = body.get_parent().get_node("RopeLinkageBottom")
			ropeTop = body.get_parent().get_node("RopeLinkageTop")
	elif body.name.contains("Ice"):
		isOnIce = true
	elif !body.name.contains("Ice") && body.name.contains("Floor"):
		isOnIce = false
	
func _on_grab_with_hands(body):
	use_hands(body)
	pass # Replace with function body.

func _on_release_with_hands(body):
	if swingRope != null:
		if body.name == swingRope.name && !isSwinging:
			isNearRope = false
			swingRope = null
			ropeTempPosition = 0
	pass

func on_grab_with_legs(body):
	use_legs(body)
	pass # Replace with function body.

func _on_release_with_legs(body):
	if swingRope != null:
		if body.name == swingRope.name && !isSwinging:
			isNearRope = false
			swingRope = null
			ropeTempPosition = 0
	pass
