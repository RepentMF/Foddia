extends CharacterBody2D

@onready var anim = $AnimatedSprite2D

const ElevationLow = 0
const ElevationHigh = 20000
const JetpackSpeed = 750
const RocketJumpSpeed = 250
const Up = Vector2(0, -1)

var checkpoint = Vector2(22, -28)
var count = 0
var countAirTime = 0
var countHangTime = 0
var countJetpackFuel = 1000
var countRocketJumps = 2

var climbXValue = 0
var climbYValue = 0
var deathParticle : PackedScene
var direction = 0
var gravity = 365
var gravityLight = 100
var gravityStandard = 365
var lastGroundDirection = 0

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
var isHoldingRope = false

var landedHard = false
var landedSoft = false
var softCount = 33
var hardCount = 200

var jumpSpeed = 100
var jumpSpeedStandard = 100
var maxJetpackFuel = 1000
var maxIceRunSpeed = 600
var maxRocketJumps = 2
var maxRunSpeed = 400
var minRunSpeed = 125
var runSpeed = 125
var swingSpeed = 0
var swingRope = null
var ropeBottom
var ropeTempPosition = 0
var ropeTop
var wasBouncing = false
var wasJumping = false
var wasFalling = false

#func _ready():
#	animatedSprite2D = $Sprite2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Temporary static rope fix that will probably be permanent
	if (isHoldingRope && ropeTempPosition.x != null && swingRope != null):
		if (global_position.x != ropeTempPosition.x + 3 && swingRope.get_parent().name.contains("Static")):
			global_position.x = ropeTempPosition.x + 3
			
	if !landedSoft && !landedHard:
		# Process player grounded animations
		if is_on_floor():
			if is_on_floor() && velocity.x == 0:
				anim.play("idle")
			elif is_on_floor() && abs(velocity.x) > minRunSpeed:
				anim.play("run")
			elif is_on_floor() && abs(velocity.x) == minRunSpeed:
				anim.play("walk")
		# Process player rope animations
		elif isHoldingRope:
			if Input.is_action_pressed("ui_up") && swingRope.get_parent().name.contains("Static"):
				anim.play("up_rope")
			elif Input.is_action_pressed("ui_down") && swingRope.get_parent().name.contains("Static"):
				anim.play("down_rope")
			else:
				anim.play("hold_rope")
		# Process player floor animations
		elif !is_on_floor():
			if wasJumping && !anim.animation == "n_jump" && !anim.animation == "arms_up" && !anim.animation == "arms_out":
				anim.play("n_jump")
			elif wasFalling && !anim.animation == "freefall_transition" && !anim.animation == "n_jump" && !anim.animation == "arms_up":
				anim.play("freefall_transition")
			
			if Input.is_action_just_released("ui_cancel"):
				anim.play("arms_up")
			elif wasFalling && Input.is_action_pressed("ui_cancel") && !anim.name == "arms_up":
				anim.play("arms_out")
			elif wasFalling && !Input.is_action_pressed("ui_cancel") && anim.name == "arms_out":
				anim.play("arms_up")
		
		if swingRope != null:
			if isHoldingRope && swingRope.get_parent().name.contains("Swinging"):
				rotation = swingRope.rotation
		else:
			if rotation > 0:
				rotation -= .005
				if rotation < 0:
					rotation = 0
			elif rotation < 0:
				rotation += .005
				if rotation > 0:
					rotation = 0
	elif landedSoft && !anim.name == "soft_land":
		anim.play("soft_land")
	elif landedHard && !anim.name == "hard_land":
		anim.play("hard_land")
		
	if direction == 1:
		anim.flip_h = false
	elif direction == -1:
		anim.flip_h = true
	pass

func _physics_process(delta):
		direction = sign(velocity.x)
	#Handle death conditions
	#if !isDead || !hasReset:
		if isDead:
			global_position = checkpoint
			isDead = false
		jumpSpeed = jumpSpeedStandard - ((abs(global_position.y) / ElevationHigh) * 20)
		# Handle grabbing rope
		if Input.is_action_pressed("ui_cancel") && isNearRope && !hasJetpack:
			isHoldingRope = true
			isOnIce = false
			countRocketJumps = maxRocketJumps
			countHangTime = 0
			runSpeed = minRunSpeed
		elif Input.is_action_just_released("ui_cancel") && !hasJetpack:
			hasReleasedRope = true
		# Handle releasing rope
		if ropeTop != null:
			if hasReleasedRope:
				countAirTime += 1
				if countAirTime > 15:
					countAirTime = 0
					isHoldingRope = false
					hasReleasedRope = false
					isNearRope = false
					swingRope = null
					wasBouncing = false
					ropeTempPosition = 0
		# Handle physics on a rope
		if !hasJetpack && swingRope != null && isHoldingRope:
			countHangTime = 0
			if isHoldingRope && swingRope.get_parent().name.contains("Swinging"):
				global_position = Vector2(swingRope.global_position.x, swingRope.global_position.y)
				if swingRope.get_parent().name.contains("Falling"):
					if swingRope.get_parent().get_node("PinJoint2D") != null:
						swingRope.get_parent().get_node("PinJoint2D").willFall = true
						if swingRope.get_parent().get_node("PinJoint2D").count == 0:
							velocity.x = 0
							velocity.y = 0
				if Input.is_action_just_pressed("ui_right"):
					swingRope.apply_impulse(Vector2(15, 0))
				elif Input.is_action_just_pressed("ui_left"):
					swingRope.apply_impulse(Vector2(-15, 0))
				elif hasReleasedRope || !swingRope.name.contains("RopeLinkage"):
					if swingRope.name.contains("Bottom") || swingRope.name.contains("10") || swingRope.name.contains("9") || swingRope.name.contains("8") || swingRope.name.contains("7"):
						velocity = ropeBottom.linear_velocity
						if isInWindCurrent:
							velocity.y = ropeBottom.linear_velocity.y * 1.6
						swingRope = null
					else:
						velocity = ropeBottom.linear_velocity / 2
						if isInWindCurrent:
							velocity.y = ropeBottom.linear_velocity.y * 1.3
						swingRope = null
			elif isHoldingRope && swingRope.get_parent().name.contains("Static"):
				global_position = global_position.move_toward(Vector2(ropeTempPosition.x, ropeTempPosition.y), 10)
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
		elif !hasJetpack && isGrabbingLedge:
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
			lastGroundDirection = sign(velocity.x)
			wasFalling = true
			if velocity.y > 0:
				countHangTime += 1
			if velocity.y > 500:
				if velocity.y > 800:
					velocity.y = 800
					isFreefalling = true
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
						#explode()
		# Handle grounded movement
		else:
			countHangTime = 0
			countRocketJumps = maxRocketJumps
			isHoldingRope = false
			wasFalling = false
			if isFreefalling:
				isFreefalling = false
			elif wasJumping:
				if (Input.is_action_pressed("ui_right") && lastGroundDirection == -1) || (Input.is_action_pressed("ui_left") && lastGroundDirection == 1):
					landedSoft = true
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
						velocity.x += 8
					else:
						velocity.x += 3
				elif Input.is_action_pressed("ui_left"):
					if isRunning:
						velocity.x += -8
					else:
						velocity.x += -3
				if abs(velocity.x) > maxIceRunSpeed:
					velocity.x = maxIceRunSpeed * sign(velocity.x)
				# Handle jumping
				if Input.is_action_just_pressed("ui_accept"):
					velocity.y = -jumpSpeed - (abs(velocity.x) * .25)
			elif !landedSoft && !landedHard:
				# Enable running toggle
				if Input.is_action_pressed("ui_select"):
					isRunning = true
				elif Input.is_action_just_released("ui_select"):
					isRunning = false
				# Handle jumping
				if Input.is_action_just_pressed("ui_accept"):
					velocity.y = -jumpSpeed - (runSpeed * .25)
					wasJumping = true
				# Handle moving left and right speeds
				if isRunning && runSpeed < maxRunSpeed:
					runSpeed += 2.5
				elif !isRunning && runSpeed > minRunSpeed:
					runSpeed -= 4
					if runSpeed < minRunSpeed:
						runSpeed = minRunSpeed
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
			elif landedSoft && softCount > 0:
				velocity = Vector2(0, 0)
				softCount -= 1
				if softCount <= 0:
					landedSoft = false
					softCount = 33
			elif landedHard && hardCount > 0:
				velocity = Vector2(0, 0)
				hardCount -= 1
				if hardCount <= 0:
					landedHard = false
					hardCount = 200
		if !hasJetpack:
			if abs(velocity.x) > 600:
				velocity.x = 600 * sign(velocity.x)
				
		move_and_slide()
		
		if isHoldingRope && swingRope != null:
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

func explode():
	var particle = deathParticle.instance()
	particle.position = global_position
	particle.rotation = global_rotation
	particle.emitting = true
	get_tree().current_scene.add_child(particle)
	pass
	
func use_hands(body):
	print(body.name)
	if body.name.contains("LedgeGrab"):
		if velocity.x != maxRunSpeed:
			climbYValue = body.global_position.y + 1
			climbXValue = body.global_position.x
			isGrabbingLedge = true
			isFreefalling = false
		elif velocity.x == maxRunSpeed:
			velocity.y = 0
			isFreefalling = true
	elif (body.name.contains("Floor") || body.name.contains("Wall")) && !isFreefalling && !isGrabbingLedge:
		if abs(velocity.x) > 525:
			isDead = true
		isFreefalling = true
		get_tree().paused = true
	elif body.name.contains("RopeLinkage") && swingRope == null:
		isNearRope = true
		if !isHoldingRope:
			swingRope = body
			if swingRope.get_parent().name.contains("Swinging"):
				var ropeImpulse = Vector2(0.5 * swingSpeed, 1)
				if abs(ropeImpulse.x) > 130:
					ropeImpulse.x = sign(ropeImpulse.x) * 130
				body.apply_impulse(ropeImpulse)
			ropeTempPosition = Vector2(swingRope.global_position.x - 4, global_position.y)
			ropeBottom = body.get_parent().get_node("RopeLinkageBottom")
			ropeTop = body.get_parent().get_node("RopeLinkageTop")
	pass

func use_legs(body):
	if body.name.contains("RopeLinkage") && swingRope == null:
		isNearRope = true
		if !isHoldingRope:
			swingRope = body
			if swingRope.get_parent().name.contains("Swinging"):
				var ropeImpulse = Vector2(0.5 * swingSpeed, 1)
				if abs(ropeImpulse.x) > 130:
					ropeImpulse.x = sign(ropeImpulse.x) * 130
				body.apply_impulse(ropeImpulse)
			ropeTempPosition = Vector2(swingRope.global_position.x - 4, global_position.y)
			ropeBottom = body.get_parent().get_node("RopeLinkageBottom")
			ropeTop = body.get_parent().get_node("RopeLinkageTop")
	elif body.name.contains("Ice"):
		isOnIce = true
	elif !body.name.contains("Ice") && body.name.contains("Floor"):
		isOnIce = false
	pass
	
func _on_grab_with_hands(body):
	use_hands(body)
	pass # Replace with function body.

func _on_release_with_hands(body):
	if swingRope != null:
		if body.name == swingRope.name && !isHoldingRope:
			isNearRope = false
			swingRope = null
			#ropeTempPosition = 0
	pass

func on_grab_with_legs(body):
	use_legs(body)
	if body.name.contains("Ice") || body.name.contains("Floor") || body.name.contains("Wall"):
		# Apply landing lag or death conditions
		if countHangTime >= 50 && countHangTime < 106:
			# Apply soft landing lag
			landedSoft = true
		elif countHangTime >= 106 && countHangTime < 137:
			# Apply hard landing lag
			landedHard = true
		if countHangTime >= 137:
			isDead = true
	pass # Replace with function body.

func _on_release_with_legs(body):
	if swingRope != null:
		if body.name == swingRope.name && !isHoldingRope:
			isNearRope = false
			swingRope = null
			#ropeTempPosition = 0
	pass
