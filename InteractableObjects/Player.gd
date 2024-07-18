extends CharacterBody2D

var anim
@onready var arms = $HandsArea2D
@onready var anim_norm = $Player_normal
@onready var anim_legs = $Player_legs
@onready var anim_rocket = $Player_rocket
@onready var anim_legs_rocket = $Player_legs_rocket
@onready var cam = %Camera2D
@onready var CRT = $CanvasLayer
@onready var timer = %TimerDisplay
@onready var dialogue = %DialogueBox

var user_prefs: UserPreferences
var explosion = preload("res://GraphicObjects/Explosion.tscn")
var smoking = preload("res://GraphicObjects/Smoking.tscn")

const ElevationLow = 0
const ElevationHigh = 20000
const JetpackSpeed = 750
const RocketJumpSpeed = 250
const Up = Vector2(0, -1)

var checkpoint = Vector2(260, 130)
var count = 0
var countAirTime = 0
var countHangTime = 0
var countJetpackFuel = 1000
var countRocketJumps = 2

var fadeInCount = 100
var game_start = true

var climbXValue = 0
var climbYValue = 0
var deathParticle : PackedScene
var direction = 0
var gravity = 365
var gravityLight = 100
var gravityStandard = 365
var lastGroundDirection = 0
var zoomStandard = Vector2(1, 1)

var hasJetpack = false
var hasMacguffin = false
var hasMacguffin2 = false
var hasNewLegs = false
var hasRocketJump = false
var hasRocketed = false
var hasReleasedRope = false

var isClimbingLedge = false
var isCrawlingLedge = false
var isDead = false
var isInElevator = false
var isInteracting = false
var isFreefalling = false
var isGrabbingLedge = false
var isInWindCurrent = false
var isInZeroG = false
var isNearRope = false
var isOnIce = false
var isRunning = false
var isHoldingRope = false

var landedHard = false
var landedSoft = false
var softCount = 33
var hardCount = 200

var hairPosition = Vector2(-6, -14)
var jumpSpeed = 100
var jumpSpeedStandard = 100
var maxJetpackFuel = 1000
var maxIceRunSpeed = 600
var maxRocketJumps = 2
var maxRunSpeed = 400
var minRunSpeed = 125
var runSpeed = 125
var smokeCount = 30
var swingSpeed = 0
var swingRope = null
var ropeBottom
var ropeTempPosition = 0
var ropeTop
var wasBouncing = false
var wasJumping = false
var wasFalling = false
var wasSwinging = false

func _ready():
	user_prefs = UserPreferences.load_or_create()
	if user_prefs.new_game:
		if user_prefs.difficulty_dropdown_index == 0:
			user_prefs.relaxed_checkpoint = Vector2(260, 130)
			user_prefs.relaxed_save = Vector2(260, 130)
			user_prefs.relaxed_boots_flag = false
			user_prefs.relaxed_rockets_flag = false
			user_prefs.relaxed_jetpack_flag = false
			user_prefs.relaxed_fuel_count = 1000
			user_prefs.relaxed_macguffin_flag = false
			user_prefs.relaxed_macguffin2_flag = false
			user_prefs.relaxed_ms = 0
			user_prefs.relaxed_s = 0
			user_prefs.relaxed_m = 0
			user_prefs.relaxed_h = 0
			user_prefs.relaxed_flag1 = false
			user_prefs.relaxed_flag2 = false
			user_prefs.relaxed_flag3 = false
			user_prefs.relaxed_flag4 = false
			user_prefs.relaxed_flag5 = false
			user_prefs.relaxed_flag6 = false
			user_prefs.relaxed_flag7 = false
			user_prefs.relaxed_flag8 = false
			user_prefs.relaxed_flag9 = false
			user_prefs.relaxed_flag10 = false
			user_prefs.relaxed_flag11 = false
			user_prefs.relaxed_flag12 = false
			user_prefs.relaxed_flag13 = false
			user_prefs.relaxed_flag14 = false
			user_prefs.save()
		elif user_prefs.difficulty_dropdown_index == 1:
			user_prefs.foddian_save = Vector2(260, 130)
			user_prefs.foddian_boots_flag = false
			user_prefs.foddian_rockets_flag = false
			user_prefs.foddian_jetpack_flag = false
			user_prefs.foddian_fuel_count = 1000
			user_prefs.foddian_macguffin_flag = false
			user_prefs.foddian_macguffin2_flag = false
			user_prefs.foddian_ms = 0
			user_prefs.foddian_s = 0
			user_prefs.foddian_m = 0
			user_prefs.foddian_h = 0
			user_prefs.foddian_flag1 = false
			user_prefs.foddian_flag11 = false
			user_prefs.save()
		user_prefs.new_game = false
		user_prefs.save()
	# Loading Relaxed Playthrough
	if user_prefs.difficulty_dropdown_index == 0:
		global_position = user_prefs.relaxed_save
		checkpoint = user_prefs.relaxed_checkpoint
		if user_prefs.relaxed_boots_flag:
			hasNewLegs = true
			maxRunSpeed *= 1.2
		if user_prefs.relaxed_rockets_flag:
			hasRocketJump = true
		if user_prefs.relaxed_jetpack_flag:
			hasJetpack = true
			countJetpackFuel = user_prefs.relaxed_fuel_count
		if user_prefs.relaxed_macguffin_flag:
			hasMacguffin = true
		if user_prefs.relaxed_macguffin2_flag:
			hasMacguffin2 = true
		timer.ms = user_prefs.relaxed_ms
		timer.s = user_prefs.relaxed_s
		timer.m = user_prefs.relaxed_m
		timer.h = user_prefs.relaxed_h
	# Loading Foddian Playthrough
	elif user_prefs.difficulty_dropdown_index == 1:
		global_position = user_prefs.foddian_save
		if user_prefs.foddian_boots_flag:
			hasNewLegs = true
			maxRunSpeed *= 1.2
		if user_prefs.foddian_rockets_flag:
			hasRocketJump = true
		if user_prefs.foddian_jetpack_flag:
			hasJetpack = true
			countJetpackFuel = user_prefs.foddian_fuel_count
		if user_prefs.foddian_macguffin_flag:
			hasMacguffin = true
		if user_prefs.foddian_macguffin2_flag:
			hasMacguffin2 = true
		timer.ms = user_prefs.foddian_ms
		timer.s = user_prefs.foddian_s
		timer.m = user_prefs.foddian_m
		timer.h = user_prefs.foddian_h
	# Loading Permadeath Playthrough
	elif user_prefs.difficulty_dropdown_index == 2:
		global_position = user_prefs.permadeath_save
		timer.ms = 0
		timer.s = 0
		timer.m = 0
		timer.h = 0
	if hasNewLegs && hasRocketJump && !hasJetpack:
		anim_norm.visible = false
		anim_legs.visible = false
		anim_rocket.visible = false
		anim_legs_rocket.visible = true
		anim = anim_legs_rocket
	elif hasNewLegs && !hasRocketJump && !hasJetpack:
		anim_norm.visible = false
		anim_legs.visible = true
		anim_rocket.visible = false
		anim_legs_rocket.visible = false
		anim = anim_legs
	elif !hasNewLegs && hasRocketJump && !hasJetpack:
		anim_norm.visible = false
		anim_legs.visible = false
		anim_rocket.visible = true
		anim_legs_rocket.visible = false
		anim = anim_rocket
	elif !hasNewLegs && !hasRocketJump && !hasJetpack:
		anim_norm.visible = true
		anim_legs.visible = false
		anim_rocket.visible = false
		anim_legs_rocket.visible = false
		anim = anim_norm
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if hasNewLegs && hasRocketJump && !hasJetpack:
		anim_norm.visible = false
		anim_legs.visible = false
		anim_rocket.visible = false
		anim_legs_rocket.visible = true
		anim = anim_legs_rocket
	elif hasNewLegs && !hasRocketJump && !hasJetpack:
		anim_norm.visible = false
		anim_legs.visible = true
		anim_rocket.visible = false
		anim_legs_rocket.visible = false
		anim = anim_legs
	elif !hasNewLegs && hasRocketJump && !hasJetpack:
		anim_norm.visible = false
		anim_legs.visible = false
		anim_rocket.visible = true
		anim_legs_rocket.visible = false
		anim = anim_rocket
	elif !hasNewLegs && !hasRocketJump && !hasJetpack:
		anim_norm.visible = true
		anim_legs.visible = false
		anim_rocket.visible = false
		anim_legs_rocket.visible = false
		anim = anim_norm
	if !isInteracting:
		if Input.is_action_just_pressed("ui_menu"):
			%PauseMenu.visible = true
			get_tree().paused = true
		CRT.visible = user_prefs.crt_bool_check
		timer.visible = user_prefs.speedrun_bool_check
		# Temporary static rope fix that will probably be permanent
		if (isHoldingRope && ropeTempPosition.x != null && swingRope != null):
			if (global_position.x != ropeTempPosition.x + 3 && swingRope.get_parent().name.contains("Static")):
				global_position.x = ropeTempPosition.x + 3
				
		if !landedSoft && !landedHard && !isGrabbingLedge && !isClimbingLedge:
			# Process player grounded animations
			if is_on_floor():
				if is_on_floor() && velocity.x == 0:
					anim.play("idle")
				elif is_on_floor() && abs(velocity.x) > minRunSpeed:
					anim.play("run")
				elif is_on_floor() && abs(velocity.x) <= minRunSpeed:
					anim.play("walk")
				if hasRocketJump:
					get_node("Rocket_1").visible = true
					get_node("Rocket_2").visible = true
			# Process player rope animations
			elif isHoldingRope && swingRope != null:
				# FIX NEEDED: cannot press up when on swinging rope
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
				
				if wasFalling && Input.is_action_pressed("ui_cancel"):
					anim.play("arms_out")
					if hasRocketJump:
						get_node("Rocket_1").visible = false
						get_node("Rocket_2").visible = false
				elif Input.is_action_just_released("ui_cancel"):
					anim.play("arms_up")
					if hasRocketJump:
						get_node("Rocket_1").visible = true
						get_node("Rocket_2").visible = true
				#elif wasFalling && !Input.is_action_pressed("ui_cancel") && anim.animation == "arms_out":
				#	anim.play("arms_up")
				
		elif landedSoft && !anim.animation == "soft_land":
			anim.play("soft_land")
		elif landedHard && !anim.animation == "hard_land":
			anim.play("hard_land")
		elif isClimbingLedge && !anim.animation == "climb_ledge":
			anim.play("climb_ledge")
		elif isGrabbingLedge && !isClimbingLedge:
			anim.play("grab_ledge")
					
		if direction == 1:
			anim.flip_h = false
			arms.position = Vector2(3, -8)
		elif direction == -1:
			anim.flip_h = true
			arms.position = Vector2(-5, -8)
			
		#Handle ponytail nonsense; in air, physics crazy, on ground, physics contained
		if !anim.flip_h:
			get_node("PinJoint2DLeft").visible = true
			get_node("PinJoint2DRight").visible = false
			get_node("PinJoint2DLeftAir").visible = false
			get_node("PinJoint2DRightAir").visible = false
			if !isHoldingRope && !is_on_floor():
				get_node("PinJoint2DLeft").visible = false
				get_node("PinJoint2DLeftAir").visible = true
				if wasBouncing || wasSwinging:
					get_node("PinJoint2DLeft").visible = true
					get_node("PinJoint2DLeftAir").visible = false
		else:
			get_node("PinJoint2DLeft").visible = false
			get_node("PinJoint2DRight").visible = true
			get_node("PinJoint2DLeftAir").visible = false
			get_node("PinJoint2DRightAir").visible = false
			if !isHoldingRope && !is_on_floor():
				get_node("PinJoint2DRight").visible = false
				get_node("PinJoint2DRightAir").visible = true
				if wasBouncing || wasSwinging:
					get_node("PinJoint2DRight").visible = true
					get_node("PinJoint2DRightAir").visible = false
		
		get_node("PinJoint2DLeft").z_index = 0
		get_node("PinJoint2DRight").z_index = 0
		
		if landedSoft || landedHard || isGrabbingLedge:
			get_node("PinJoint2DLeft").visible = false
			get_node("PinJoint2DRight").visible = false
			get_node("PinJoint2DLeftAir").visible = false
			get_node("PinJoint2DRightAir").visible = false
			if hasRocketJump:
				get_node("Rocket_1").visible = false
				get_node("Rocket_2").visible = false
		elif isHoldingRope && !is_on_floor():
			get_node("PinJoint2DLeft").z_index = 1
			get_node("PinJoint2DRight").z_index = 1
	pass

func _physics_process(delta):
	if game_start:
		if fadeInCount > 0:
			fadeInCount -= 1
		elif fadeInCount == 0:
			game_start = false
			%FadeInPanel.visible = false
	if !isInteracting:
		direction = sign(velocity.x)
		#Handle death conditions
		#if !isDead || !hasReset:
		if isDead:
			global_position = checkpoint
			isDead = false
		jumpSpeed = jumpSpeedStandard - ((abs(global_position.y) / ElevationHigh) * 20)
		var zoomTemp = (0.5 * ((ElevationHigh - abs(global_position.y)) / ElevationHigh)) + 0.6
		cam.zoom = Vector2(zoomTemp, zoomTemp)
		# Handle grabbing rope
		if Input.is_action_pressed("ui_cancel") && isNearRope && (!hasJetpack && countJetpackFuel > 0):
			isHoldingRope = true
			isOnIce = false
			countRocketJumps = maxRocketJumps
			countHangTime = 0
			runSpeed = minRunSpeed
			if hasRocketJump:
				get_node("Rocket_1").visible = false
				get_node("Rocket_2").visible = false
		elif Input.is_action_just_released("ui_cancel") && (!hasJetpack && countJetpackFuel > 0):
			hasReleasedRope = true
		# Enable running toggle
		if Input.is_action_pressed("ui_select"):
			isRunning = true
		elif Input.is_action_just_released("ui_select"):
			isRunning = false
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
					wasSwinging = true
					ropeTempPosition = 0
					if abs(velocity.x) < maxRunSpeed:
						runSpeed = abs(velocity.x)
					if abs(velocity.x) >= maxRunSpeed:
						runSpeed = maxRunSpeed
					if hasRocketJump:
						get_node("Rocket_1").visible = true
						get_node("Rocket_2").visible = true
						$Rocket_1.rotation = 3.14159
						$Rocket_2.rotation = 3.14159
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
		elif isGrabbingLedge:
			velocity.x = 0
			velocity.y = 0
			countHangTime = 0
			isDead = false
			if isCrawlingLedge:
				crawl_ledge()
			elif isClimbingLedge:
				ascend_ledge()
			elif Input.is_action_pressed("ui_accept"):
				isClimbingLedge = true
				ascend_ledge()
		# Add the gravity, handle aerial movement and calculations
		elif !is_on_floor():
			if isInZeroG:
				gravity = -3
			elif isInWindCurrent:
				gravity = gravityLight
			else:
				gravity = gravityStandard
			velocity.y += gravity * delta
			lastGroundDirection = sign(velocity.x)
			wasFalling = true
			if velocity.y > 0:
				countHangTime += 1
			elif wasSwinging:
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
						countHangTime = 0
						countAirTime = 0
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
						if countJetpackFuel % 10 == 0:
							smoke()
				elif hasRocketJump:
					if hasRocketed:
						smokeCount -= 1
						if smokeCount > 0:
							smoke()
						else:
							smokeCount = 30
							hasRocketed = false
					if Input.is_action_just_pressed("ui_accept") && countRocketJumps > 0:
						hasRocketed = true
						countRocketJumps -= 1
						countHangTime = 0
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
						explode()
						$Rocket_1.rotation = 0
						$Rocket_2.rotation = 0
						if Input.is_action_pressed("ui_right"):
							$Rocket_1.rotation = 1.5708
							$Rocket_2.rotation = 1.5708
						elif Input.is_action_pressed("ui_left"):
							$Rocket_1.rotation = -1.5708
							$Rocket_2.rotation = -1.5708
						elif Input.is_action_pressed("ui_up"):
							$Rocket_1.rotation = 0
							$Rocket_2.rotation = 0
						elif Input.is_action_pressed("ui_down"):
							$Rocket_1.rotation = 3.14159
							$Rocket_2.rotation = 3.14159
						if Input.is_action_pressed("ui_right") && Input.is_action_pressed("ui_up"):
							$Rocket_1.rotation = 0.785398
							$Rocket_2.rotation = 0.785398
						elif Input.is_action_pressed("ui_left") && Input.is_action_pressed("ui_up"):
							$Rocket_1.rotation = -0.785398
							$Rocket_2.rotation = -0.785398
						elif Input.is_action_pressed("ui_right") && Input.is_action_pressed("ui_down"):
							$Rocket_1.rotation = 2.35619
							$Rocket_2.rotation = 2.35619
						elif Input.is_action_pressed("ui_left") && Input.is_action_pressed("ui_down"):
							$Rocket_1.rotation = -2.35619
							$Rocket_2.rotation = -2.35619
		# Handle grounded movement
		else:
			#if wasSwinging:
				#print(runSpeed)
			hasRocketed = false
			smokeCount = 30
			countHangTime = 0
			countRocketJumps = maxRocketJumps
			isHoldingRope = false
			wasFalling = false
			wasSwinging = false
			if isFreefalling:
				isFreefalling = false
			elif wasJumping:
				if (Input.is_action_pressed("ui_right") && lastGroundDirection == -1) || (Input.is_action_pressed("ui_left") && lastGroundDirection == 1):
					landedSoft = true
				wasJumping = false
			if isOnIce && !landedSoft && !landedHard:
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
				runSpeed = minRunSpeed
				softCount -= 1
				if softCount <= 0:
					landedSoft = false
					softCount = 33
			elif landedHard && hardCount > 0:
				velocity = Vector2(0, 0)
				runSpeed = minRunSpeed
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
			if swingRope.get_parent().name.contains("Swinging"):
				rotation = swingRope.rotation
		else:
			swingSpeed = velocity.x
			
		if swingRope == null:
			# On desktop .005 decrement, on laptop .05 decrement
			if rotation > 0:
				rotation -= .15
				if rotation < 0:
					rotation = 0
			elif rotation < 0:
				rotation += .15
				if rotation > 0:
					rotation = 0
		timer.rotation = 0
		if NOTIFICATION_WM_CLOSE_REQUEST:
			if user_prefs.difficulty_dropdown_index == 0:
				user_prefs.relaxed_save = global_position
				user_prefs.relaxed_checkpoint = checkpoint
				user_prefs.relaxed_boots_flag = hasNewLegs
				user_prefs.relaxed_rockets_flag = hasRocketJump
				user_prefs.relaxed_jetpack_flag = hasJetpack
				user_prefs.relaxed_fuel_count = countJetpackFuel
				user_prefs.relaxed_macguffin_flag = hasMacguffin
				user_prefs.relaxed_macguffin2_flag = hasMacguffin2
				user_prefs.relaxed_ms = timer.ms
				user_prefs.relaxed_s = timer.s
				user_prefs.relaxed_m = timer.m
				user_prefs.relaxed_h = timer.h
				user_prefs.save()
			elif user_prefs.difficulty_dropdown_index == 1:
				user_prefs.foddian_save = global_position
				user_prefs.foddian_checkpoint = checkpoint
				user_prefs.foddian_boots_flag = hasNewLegs
				user_prefs.foddian_rockets_flag = hasRocketJump
				user_prefs.foddian_jetpack_flag = hasJetpack
				user_prefs.foddian_fuel_count = countJetpackFuel
				user_prefs.foddian_macguffin_flag = hasMacguffin
				user_prefs.foddian_macguffin2_flag = hasMacguffin2
				user_prefs.foddian_ms = timer.ms
				user_prefs.foddian_s = timer.s
				user_prefs.foddian_m = timer.m
				user_prefs.foddian_h = timer.h
				user_prefs.save()
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
	var instance = explosion.instantiate()
	add_child(instance)
	pass

func smoke():
	var instance = smoking.instantiate()
	add_child(instance)
	pass

func use_hands(body):
	if !hasRocketJump && !hasJetpack && body.name.contains("LedgeGrab"):
		#if velocity.x != maxRunSpeed:
		climbYValue = body.global_position.y + 1
		climbXValue = body.global_position.x
		isGrabbingLedge = true
		isFreefalling = false
		#elif velocity.x == maxRunSpeed:
		#	velocity.y = 0
		#	isFreefalling = true
	#elif (body.name.contains("Floor") || body.name.contains("Wall")) && !isFreefalling && !isGrabbingLedge:
	#	if abs(velocity.x) > 525:
	#		isDead = true
	#	isFreefalling = true
	#	print(405)
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
		if wasSwinging && isRunning:
			landedSoft = false
			landedHard = false
		elif countHangTime >= 50 && countHangTime < 106 && (!isRunning) || (countHangTime >= 150 && countHangTime < 249 && isInWindCurrent):
			# Apply soft landing lag
			landedSoft = true
		elif countHangTime >= 106 || (countHangTime >= 250 && isInWindCurrent):
			# Apply hard landing lag
			landedHard = true
		if countHangTime >= 137 && !isInWindCurrent:
			isDead = true
		elif countHangTime >= 400 && isInWindCurrent:
			isDead = true
	if isInElevator:
		isDead = false
	pass # Replace with function body.

func _on_release_with_legs(body):
	if swingRope != null:
		if body.name == swingRope.name && !isHoldingRope:
			isNearRope = false
			swingRope = null
			#ropeTempPosition = 0
	pass
