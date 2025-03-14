extends CharacterBody2D

var anim
var temp_volume
@onready var arms = $HandsArea2D
@onready var anim_norm = $Player_normal
@onready var anim_legs = $Player_legs
@onready var anim_rocket = $Player_rocket
@onready var anim_jetpack = $Player_jetpack
@onready var anim_legs_rocket = $Player_legs_rocket
@onready var anim_rocket_jetpack = $Player_rocket_jetpack
@onready var anim_legs_jetpack = $Player_legs_jetpack
@onready var anim_robot = $Player_robot
@onready var cam = %Camera2D
@onready var CRT = $CanvasLayer
@onready var timer = %TimerDisplay
@onready var fuel = %FuelDisplay
@onready var jetpack = %JetpackDisplay
@onready var rocket1 = %Rocket1Display
@onready var rocket2 = %Rocket2Display
@onready var macguffin = %MacguffinDisplay
@onready var macguffin2 = %Macguffin2Display
@onready var macguffin3 = %Macguffin3Display
@onready var dialogue = %DialogueBox

var user_prefs: UserPreferences
var rs
var explosion = preload("res://GraphicObjects/Explosion.tscn")
var smoking = preload("res://GraphicObjects/Smoking.tscn")

var badEnding = false
var anEnding = false

const ElevationLow = 0
const ElevationHigh = 20000
const JetpackSpeed = 750
const RocketJumpSpeed = 250
const Up = Vector2(0, -1)

var areaName = ""
var checkpoint = Vector2(260, 130)
var count = 0
var countAirTime = 0
var countBounces = 0
var countHangTime = 0
var countJetpackFuel = 1000.0
var countNoKicks = 0
var countRocketJumps = 2

var fadeInCount = 200
var game_start = true
var pausePressed = false

var changeControls = false
var changeSwinging = false
var climbXValue = 0
var climbYValue = 0
var currentConfirmMethod
var currentMoveMethod
var currentSwingMethod
var deathParticle : PackedScene
var direction = 0
var gravity = 365
var gravityLight = 100
var gravityStandard = 365
var lastGroundDirection = 0
var lastConfirmMethod
var lastMoveMethod
var lastSwingMethod
var zoomStandard = Vector2(1, 1)

var hasJetpack = false
var hasMacguffin = false
var hasMacguffin2 = false
var hasMacguffin3 = false
var hasMP3 = false
var hasNewLegs = false
var hasRocketJump = false
var hasRocketed = false
var hasReleasedRope = false

var isClimbingLedge = false
var isCrawlingLedge = false
var isDead = false
var isInElevator = false
var isInteracting = false
var isJetpacking = false
var isKicking = true
var isFreefalling = false
var isGrabbingLedge = false
var isInWindCurrent = false
var isInZeroG = false
var isNearRope = false
var isOnIce = false
var isRunning = false
var isHoldingRope = false
var jortTeleport = false

var landedHard = false
var landedSoft = false
var softCount = 33
var hardCount = 200

var deadFadeCount = 0
var forceDied = false
var hairPosition = Vector2(-6, -14)
var jumpSpeed = 100
var jumpSpeedStandard = 100
var maxJetpackFuel = 1000.0
var maxIceRunSpeed = 600
var maxRocketJumps = 2
var maxRunSpeed = 400
var minRunSpeed = 125
var runSpeed = 125
var smokeCount = 30
var staticSwingingChecked = false
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
	rs = RenderingServer
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
			user_prefs.relaxed_macguffin3_flag = false
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
			user_prefs.foddian_macguffin3_flag = false
			user_prefs.foddian_ms = 0
			user_prefs.foddian_s = 0
			user_prefs.foddian_m = 0
			user_prefs.foddian_h = 0
			user_prefs.foddian_flag1 = false
			user_prefs.foddian_flag11 = false
			user_prefs.save()
		elif user_prefs.difficulty_dropdown_index == 2:
			user_prefs.permadeath_save = Vector2(260, 130)
			user_prefs.permadeath_boots_flag = false
			user_prefs.permadeath_rockets_flag = false
			user_prefs.permadeath_jetpack_flag = false
			user_prefs.permadeath_fuel_count = 1000
			user_prefs.permadeath_macguffin_flag = false
			user_prefs.permadeath_macguffin2_flag = false
			user_prefs.permadeath_macguffin3_flag = false
			user_prefs.permadeath_ms = 0
			user_prefs.permadeath_s = 0
			user_prefs.permadeath_m = 0
			user_prefs.permadeath_h = 0
			user_prefs.permadeath_flag1 = false
			user_prefs.permadeath_flag11 = false
			user_prefs.save()
		user_prefs.new_game = false
		user_prefs.save()
	# Loading Relaxed Playthrough
	if user_prefs.difficulty_dropdown_index == 0:
		rs.set_default_clear_color(Color (.52, .74, .99, 1))
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
		if user_prefs.relaxed_macguffin3_flag:
			hasMacguffin3 = true
		timer.ms = user_prefs.relaxed_ms
		timer.s = user_prefs.relaxed_s
		timer.m = user_prefs.relaxed_m
		timer.h = user_prefs.relaxed_h
	# Loading Foddian Playthrough
	elif user_prefs.difficulty_dropdown_index == 1:
		rs.set_default_clear_color(Color (.06, .17, .31, 1))
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
		if user_prefs.foddian_macguffin3_flag:
			hasMacguffin3 = true
		timer.ms = user_prefs.foddian_ms
		timer.s = user_prefs.foddian_s
		timer.m = user_prefs.foddian_m
		timer.h = user_prefs.foddian_h
	# Loading Permadeath Playthrough
	elif user_prefs.difficulty_dropdown_index == 2:
		rs.set_default_clear_color(Color (.33, .22, .718, 1))
		global_position = user_prefs.permadeath_save
		if user_prefs.permadeath_boots_flag:
			hasNewLegs = true
			maxRunSpeed *= 1.2
		if user_prefs.permadeath_rockets_flag:
			hasRocketJump = true
		if user_prefs.permadeath_jetpack_flag:
			hasJetpack = true
			countJetpackFuel = user_prefs.permadeath_fuel_count
		if user_prefs.permadeath_macguffin_flag:
			hasMacguffin = true
		if user_prefs.permadeath_macguffin2_flag:
			hasMacguffin2 = true
		if user_prefs.permadeath_macguffin3_flag:
			hasMacguffin3 = true
		timer.ms = user_prefs.permadeath_ms
		timer.s = user_prefs.permadeath_s
		timer.m = user_prefs.permadeath_m
		timer.h = user_prefs.permadeath_h
	if user_prefs.hasMP3:
		hasMP3 = true
	# Case Robot
	if hasNewLegs && hasRocketJump && hasJetpack:
		anim_norm.visible = false
		anim_legs.visible = false
		anim_rocket.visible = false
		anim_jetpack.visible = false
		anim_rocket_jetpack.visible = false
		anim_legs_jetpack.visible = false
		anim_legs_rocket.visible = false
		anim_robot.visible = true
		anim = anim_robot
	# Case RJ
	elif !hasNewLegs && hasRocketJump && !hasJetpack:
		anim_norm.visible = false
		anim_legs.visible = false
		anim_rocket.visible = false
		anim_jetpack.visible = false
		anim_rocket_jetpack.visible = true
		anim_legs_jetpack.visible = false
		anim_legs_rocket.visible = false
		anim_robot.visible = false
		anim = anim_rocket_jetpack
	# Case LJ
	elif hasNewLegs && !hasRocketJump && hasJetpack:
		anim_norm.visible = false
		anim_legs.visible = false
		anim_rocket.visible = false
		anim_jetpack.visible = false
		anim_rocket_jetpack.visible = false
		anim_legs_jetpack.visible = true
		anim_legs_rocket.visible = false
		anim_robot.visible = false
		anim = anim_legs_jetpack
	# Case LR
	elif hasNewLegs && hasRocketJump && !hasJetpack:
		anim_norm.visible = false
		anim_legs.visible = false
		anim_rocket.visible = false
		anim_jetpack.visible = false
		anim_rocket_jetpack.visible = false
		anim_legs_jetpack.visible = false
		anim_legs_rocket.visible = true
		anim_robot.visible = false
		anim = anim_robot
		anim = anim_legs_rocket
	# Case Legs
	elif hasNewLegs && !hasRocketJump && !hasJetpack:
		anim_norm.visible = false
		anim_legs.visible = true
		anim_rocket.visible = false
		anim_jetpack.visible = false
		anim_legs_rocket.visible = false
		anim_rocket_jetpack.visible = false
		anim_legs_jetpack.visible = false
		anim_legs_rocket.visible = false
		anim_robot.visible = false
		anim = anim_legs
	# Case Rocket
	elif !hasNewLegs && hasRocketJump && !hasJetpack:
		anim_norm.visible = false
		anim_legs.visible = false
		anim_rocket.visible = true
		anim_jetpack.visible = false
		anim_legs_rocket.visible = false
		anim_rocket_jetpack.visible = false
		anim_legs_jetpack.visible = false
		anim_legs_rocket.visible = false
		anim_robot.visible = false
		anim = anim_rocket
	# Case Jetpack
	elif !hasNewLegs && !hasRocketJump && hasJetpack:
		anim_norm.visible = false
		anim_legs.visible = false
		anim_rocket.visible = false
		anim_jetpack.visible = true
		anim_legs_rocket.visible = false
		anim_rocket_jetpack.visible = false
		anim_legs_jetpack.visible = false
		anim_legs_rocket.visible = false
		anim_robot.visible = false
		anim = anim_jetpack
	# Case Human
	elif !hasNewLegs && !hasRocketJump && !hasJetpack:
		anim_norm.visible = true
		anim_legs.visible = false
		anim_rocket.visible = false
		anim_jetpack.visible = false
		anim_legs_rocket.visible = false
		anim_rocket_jetpack.visible = false
		anim_legs_jetpack.visible = false
		anim_legs_rocket.visible = false
		anim_robot.visible = false
		anim = anim_norm
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	check_controls()
	check_swinging()
	if temp_volume != %SFXVolumeHandler.SFX_volume:
		temp_volume = %SFXVolumeHandler.SFX_volume
		get_node("GrabLedge").volume_db = temp_volume
	fuel.value = (countJetpackFuel / maxJetpackFuel) * 100
	if isHoldingRope:
		isGrabbingLedge = false
	if hasJetpack:
		fuel.visible = true
		%FuelContainer.visible = true
		jetpack.visible = true
	else:
		fuel.visible = false
		jetpack.visible = false
	if hasRocketJump:
		rocket1.visible = true
		rocket2.visible = true
	else:
		rocket1.visible = false
		rocket2.visible = false
	if hasMacguffin:
		macguffin.visible = true
	else:
		macguffin.visible = false
	if hasMacguffin2:
		macguffin2.visible = true
	else:
		macguffin2.visible = false
	if hasMacguffin3:
		macguffin3.visible = true
	else:
		macguffin3.visible = false
	if countRocketJumps == 2:
		rocket1.modulate = Color(1, 1, 1, 1)
		rocket2.modulate = Color(1, 1, 1, 1)
	elif countRocketJumps == 1:
		rocket1.modulate = Color(.35, .33, 1, 1)
	elif countRocketJumps == 0:
		rocket2.modulate = Color(.35, .33, 1, 1)
	# Case Robot
	if hasNewLegs && hasRocketJump && hasJetpack:
		anim_norm.visible = false
		anim_legs.visible = false
		anim_rocket.visible = false
		anim_jetpack.visible = false
		anim_rocket_jetpack.visible = false
		anim_legs_jetpack.visible = false
		anim_legs_rocket.visible = false
		anim_robot.visible = true
		anim = anim_robot
	# Case RJ
	elif !hasNewLegs && hasRocketJump && hasJetpack:
		anim_norm.visible = false
		anim_legs.visible = false
		anim_rocket.visible = false
		anim_jetpack.visible = false
		anim_rocket_jetpack.visible = true
		anim_legs_jetpack.visible = false
		anim_legs_rocket.visible = false
		anim_robot.visible = false
		anim = anim_rocket_jetpack
	# Case LJ
	elif hasNewLegs && !hasRocketJump && hasJetpack:
		anim_norm.visible = false
		anim_legs.visible = false
		anim_rocket.visible = false
		anim_jetpack.visible = false
		anim_rocket_jetpack.visible = false
		anim_legs_jetpack.visible = true
		anim_legs_rocket.visible = false
		anim_robot.visible = false
		anim = anim_legs_jetpack
	# Case LR
	elif hasNewLegs && hasRocketJump && !hasJetpack:
		anim_norm.visible = false
		anim_legs.visible = false
		anim_rocket.visible = false
		anim_jetpack.visible = false
		anim_rocket_jetpack.visible = false
		anim_legs_jetpack.visible = false
		anim_legs_rocket.visible = true
		anim_robot.visible = false
		anim = anim_legs_rocket
	# Case Legs
	elif hasNewLegs && !hasRocketJump && !hasJetpack:
		anim_norm.visible = false
		anim_legs.visible = true
		anim_rocket.visible = false
		anim_jetpack.visible = false
		anim_legs_rocket.visible = false
		anim_rocket_jetpack.visible = false
		anim_legs_jetpack.visible = false
		anim_legs_rocket.visible = false
		anim_robot.visible = false
		anim = anim_legs
	# Case Rocket
	elif !hasNewLegs && hasRocketJump && !hasJetpack:
		anim_norm.visible = false
		anim_legs.visible = false
		anim_rocket.visible = true
		anim_jetpack.visible = false
		anim_legs_rocket.visible = false
		anim_rocket_jetpack.visible = false
		anim_legs_jetpack.visible = false
		anim_legs_rocket.visible = false
		anim_robot.visible = false
		anim = anim_rocket
	# Case Jetpack
	elif !hasNewLegs && !hasRocketJump && hasJetpack:
		anim_norm.visible = false
		anim_legs.visible = false
		anim_rocket.visible = false
		anim_jetpack.visible = true
		anim_legs_rocket.visible = false
		anim_rocket_jetpack.visible = false
		anim_legs_jetpack.visible = false
		anim_legs_rocket.visible = false
		anim_robot.visible = false
		anim = anim_jetpack
	# Case Human
	elif !hasNewLegs && !hasRocketJump && !hasJetpack:
		anim_norm.visible = true
		anim_legs.visible = false
		anim_rocket.visible = false
		anim_jetpack.visible = false
		anim_legs_rocket.visible = false
		anim_rocket_jetpack.visible = false
		anim_legs_jetpack.visible = false
		anim_legs_rocket.visible = false
		anim_robot.visible = false
		anim = anim_norm
	if !isInteracting:
		if Input.is_action_just_pressed("ui_menu") && !pausePressed:
			%AreaTitleCard.visible = false
			%PauseMenu.visible = true
			pausePressed = true
			get_tree().paused = true
		elif Input.is_action_just_pressed("ui_menu") && pausePressed:
			pausePressed = false
		CRT.visible = user_prefs.crt_bool_check
		# Temporary static rope fix that will probably be permanent
		if (isHoldingRope && ropeTempPosition.x != null && swingRope != null):
			if (global_position.x != ropeTempPosition.x + 3 && swingRope.get_parent().name.contains("Static")):
				global_position.x = ropeTempPosition.x + 3
				
		if !landedSoft && !landedHard && !isGrabbingLedge && !isClimbingLedge:
			# Process player grounded animations
			if is_on_floor():
				if !isHoldingRope:
					if is_on_floor() && velocity.x == 0:
						anim.play("idle")
					elif is_on_floor() && abs(velocity.x) > minRunSpeed:
						anim.play("run")
					elif is_on_floor() && abs(velocity.x) <= minRunSpeed:
						anim.play("walk")
				elif isHoldingRope:
					anim.stop()
					if Input.is_action_pressed("ui_up") && !isKicking:
						anim.play("up_rope")
					elif Input.is_action_pressed("ui_down") && !isKicking:
						anim.play("down_rope")
					else:
						anim.play("hold_rope")
				if hasRocketJump:
					get_node("Rocket_1").visible = true
					get_node("Rocket_2").visible = true
			# Process player rope animations
			elif isHoldingRope && swingRope != null:
				# FIX NEEDED: cannot press up when on swinging rope
				if Input.is_action_pressed("ui_up") && !isKicking:
					anim.play("up_rope")
				elif Input.is_action_pressed("ui_down") && !isKicking:
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
		handle_ponytail()
	pass

func _physics_process(delta):
	if !isInElevator:
		collision_layer = 1
		collision_mask = 1
	if game_start:
		CRT.visible = user_prefs.crt_bool_check
		if fadeInCount < 173:
			%Loading.visible = true
		if fadeInCount > 0:
			fadeInCount -= 1
			timer.visible = false
		elif fadeInCount == 0:
			game_start = false
			%FadeInPanel.visible = false
			%Loading.visible = false
			%AreaTitleCard.visible = true
	if !isInteracting && fadeInCount <= 50:
		if forceDied:
			isDead = true
		if direction != sign(velocity.x) && velocity.x != 0:
			direction = sign(velocity.x)
		if isDead:
			$AudioPlayer.dead = true
			global_position = checkpoint
			countRocketJumps = maxRocketJumps
			countJetpackFuel = maxJetpackFuel
			%FadeInPanel.visible = true
			%FadeInPanel.color = Color(1, 0, 0, 1)
			%CamMesh.isDead = true
			if badEnding:
				user_prefs.bad_ending = true
				user_prefs.save()
				get_tree().quit()
			else:
				isDead = false
		elif %FadeInPanel.visible && !isInZeroG && !anEnding && !game_start:
			if %FadeInPanel.color == Color(0, 0, 0, 1):
				%FadeInPanel.visible = false
				deadFadeCount = 0
			if %FadeInPanel.color.r != 0 && deadFadeCount > 10:
				%FadeInPanel.color.r -= .25
			elif %FadeInPanel.color.r == 0:
				%FadeInPanel.color = Color(0, 0, 0, 1)
			deadFadeCount += 1
		jumpSpeed = jumpSpeedStandard - ((abs(global_position.y) / ElevationHigh) * 20)
		var zoomTemp = (0.5 * ((ElevationHigh - abs(global_position.y)) / ElevationHigh)) + 0.6
		cam.zoom = Vector2(zoomTemp, zoomTemp)
		# Handle grabbing rope
		if Input.is_action_pressed("ui_cancel") && isNearRope && (!hasJetpack && countJetpackFuel > 0) && !isInElevator && (!is_on_floor() || (is_on_floor() && global_position.y < ropeTop.global_position.y + 24)):
			isHoldingRope = true
			isOnIce = false
			countRocketJumps = maxRocketJumps
			rocket1.modulate = Color(1, 1, 1, 1)
			rocket2.modulate = Color(1, 1, 1, 1)
			countHangTime = 0
			runSpeed = minRunSpeed
			countBounces = 0
			if hasRocketJump:
				get_node("Rocket_1").visible = false
				get_node("Rocket_2").visible = false
				smokeCount = 30
				hasRocketed = false
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
		if !hasJetpack && swingRope != null && isHoldingRope && ((!is_on_floor() && global_position.y > ropeTop.global_position.y - 26) || (is_on_floor() && global_position.y < ropeTop.global_position.y + 26)):
			countHangTime = 0
			if Input.is_action_just_pressed("ui_right") || Input.is_action_just_pressed("ui_left"):
				isKicking = true
				countNoKicks = 0
				staticSwingingChecked = false
			elif swingRope.get_parent().get_node("RopeLinkageBottom") != null:
				if round(abs(swingRope.get_parent().get_node("RopeLinkageBottom").linear_velocity.x)) <= 0:
					countNoKicks += 1
					if countNoKicks > 30:
						isKicking = false
			if isHoldingRope && swingRope.get_parent().name.contains("Swinging"):
				if isKicking:
					global_position = Vector2(swingRope.global_position.x, swingRope.global_position.y)
					if swingRope.get_parent().name.contains("Falling"):
						if swingRope.get_parent().get_node("PinJoint2D") != null:
							swingRope.get_parent().get_node("PinJoint2D").willFall = true
							if swingRope.get_parent().get_node("PinJoint2D").count == 0:
								velocity.x = 0
								velocity.y = 0
					if Input.is_action_just_pressed("ui_right"):
						swingRope.apply_impulse(Vector2(15, 0))
						smoke()
					elif Input.is_action_just_pressed("ui_left"):
						swingRope.apply_impulse(Vector2(-15, 0))
						smoke()
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
				else:
					if !staticSwingingChecked:
						ropeTempPosition.x = swingRope.global_position.x
						ropeTempPosition.y = swingRope.global_position.y
						staticSwingingChecked = true
					global_position = Vector2(ropeTempPosition.x, ropeTempPosition.y)
					velocity = Vector2(0, 0)
					if global_position.y > ropeBottom.global_position.y + 20 || global_position.y < ropeTop.global_position.y - 26 || Input.is_action_just_released("ui_cancel"):
						hasReleasedRope = true
					elif Input.is_action_pressed("ui_up"):
						global_position.y = ropeTempPosition.y - 2
						ropeTempPosition.y = global_position.y
						if global_position.y < ropeTop.global_position.y - 26:
							global_position.y = ropeTop.global_position.y - 26
							ropeTempPosition.y = ropeTop.global_position.y - 26
							runSpeed = minRunSpeed
					elif Input.is_action_pressed("ui_down"):
						global_position.y = ropeTempPosition.y + 2
						ropeTempPosition.y = global_position.y
						if global_position.y > ropeBottom.global_position.y + 20:
							hasReleasedRope = true
							countAirTime = 10
							countNoKicks = 0
							staticSwingingChecked = false
			elif isHoldingRope && (swingRope.get_parent().name.contains("Static")):
				global_position = global_position.move_toward(Vector2(ropeTempPosition.x, ropeTempPosition.y), 10)
				velocity = Vector2(0, 0)
				# If player is higher than top of rope/ lower than bottom of rope/ releases grab button, do next
				if global_position.y > ropeBottom.global_position.y + 20 || global_position.y < ropeTop.global_position.y - 26 || Input.is_action_just_released("ui_cancel"):
					hasReleasedRope = true
				elif Input.is_action_pressed("ui_up"):
					global_position.y = ropeTempPosition.y - 2
					ropeTempPosition.y = global_position.y
					if global_position.y < ropeTop.global_position.y - 26:
						global_position.y = ropeTop.global_position.y - 26
						ropeTempPosition.y = ropeTop.global_position.y - 26
						runSpeed = minRunSpeed
						velocity.x = runSpeed
				elif Input.is_action_pressed("ui_down"):
					global_position.y = ropeTempPosition.y + 2
					ropeTempPosition.y = global_position.y
					if global_position.y > ropeBottom.global_position.y + 20:
						hasReleasedRope = true
						countAirTime = 10
						velocity = Vector2(0, 0)
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
			elif Input.is_action_pressed("ui_jump"):
				isClimbingLedge = true
				ascend_ledge()
		# Add the gravity, handle aerial movement and calculations
		elif !is_on_floor():
			if isInZeroG:
				gravity = -1
			elif isInWindCurrent:
				gravity = gravityLight
			else:
				gravity = gravityStandard
			velocity.y += gravity * delta
			lastGroundDirection = direction
			wasFalling = true
			if velocity.y > 0:
				countHangTime += 1
			elif wasSwinging:
				countHangTime += 1
			if velocity.y > 500 && !isJetpacking:
				if velocity.y > 800:
					velocity.y = 800
					isFreefalling = true
			# Handle jetpack or rocket jumps
			if !isFreefalling:
				if hasJetpack:
					if Input.is_action_pressed("ui_jump") && countJetpackFuel > 0:
						isJetpacking = true
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
						if int (countJetpackFuel) % 10 == 0:
							smoke()
					elif !Input.is_action_pressed("ui_jump") || countJetpackFuel <= 0:
						isJetpacking = false
				elif hasRocketJump:
					if hasRocketed:
						smokeCount -= 1
						if smokeCount > 0:
							smoke()
						else:
							smokeCount = 30
							hasRocketed = false
					if Input.is_action_just_pressed("ui_jump") && countRocketJumps > 0:
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
			isKicking = true
			countNoKicks = 0
			staticSwingingChecked = false
			countBounces = 0
			hasRocketed = false
			smokeCount = 30
			countHangTime = 0
			countRocketJumps = maxRocketJumps
			if rocket1 != null && rocket2 != null:
				rocket1.modulate = Color(1, 1, 1, 1)
				rocket2.modulate = Color(1, 1, 1, 1)
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
				if Input.is_action_just_pressed("ui_jump"):
					velocity.y = -jumpSpeed - (abs(velocity.x) * .25)
			elif !landedSoft && !landedHard:
				# Enable running toggle
				if Input.is_action_pressed("ui_select"):
					isRunning = true
				elif Input.is_action_just_released("ui_select"):
					isRunning = false
				# Handle jumping
				if Input.is_action_just_pressed("ui_jump"):
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
		
		if swingRope != null:
			if isHoldingRope && swingRope.get_parent().name.contains("Swinging"):
					if isKicking:
						global_position = Vector2(swingRope.global_position.x, swingRope.global_position.y)
		
		if isHoldingRope && swingRope != null:
			swingSpeed = swingRope.linear_velocity.x
			if swingRope.get_parent().name.contains("Swinging"):
				rotation = swingRope.rotation
				if abs(rotation) > 1.2:
					rotation = sign(rotation) * 1.2
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

func handle_ponytail():
	if !anim.flip_h:
		get_node("PinJoint2DLeft").visible = true
		get_node("PinJoint2DRight").visible = false
		get_node("PinJoint2DLeftAir").visible = false
		get_node("PinJoint2DRightAir").visible = false
		if !isHoldingRope && !is_on_floor():
			get_node("PinJoint2DLeft").visible = false
			get_node("PinJoint2DLeftAir").visible = true
			#if wasBouncing || wasSwinging:
			#	get_node("PinJoint2DLeft").visible = true
			#	get_node("PinJoint2DLeftAir").visible = false
	else:
		get_node("PinJoint2DLeft").visible = false
		get_node("PinJoint2DRight").visible = true
		get_node("PinJoint2DLeftAir").visible = false
		get_node("PinJoint2DRightAir").visible = false
		if !isHoldingRope && !is_on_floor():
			get_node("PinJoint2DRight").visible = false
			get_node("PinJoint2DRightAir").visible = true
			#if wasBouncing || wasSwinging:
			#	get_node("PinJoint2DRight").visible = true
			#	get_node("PinJoint2DRightAir").visible = false
		
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

func smoke():
	var instance = smoking.instantiate()
	add_child(instance)
	pass

func use_hands(body):
	if !hasRocketJump && !hasJetpack && body.name.contains("LedgeGrab") && Input.is_action_pressed("ui_cancel"):
		#if velocity.x != maxRunSpeed:
		climbYValue = body.global_position.y + 1
		climbXValue = body.global_position.x
		isGrabbingLedge = true
		isFreefalling = false
		get_node("GrabLedge").play()
	elif body.name.contains("RopeLinkage") && swingRope == null && !isInElevator:
		isNearRope = true
		if !isHoldingRope:
			swingRope = body
			ropeTempPosition = Vector2(swingRope.global_position.x - 4, global_position.y)
			if swingRope.get_parent().name.contains("Swinging"):
				var ropeImpulse = Vector2(0.5 * swingSpeed, 1)
				if abs(ropeImpulse.x) > 130:
					ropeImpulse.x = sign(ropeImpulse.x) * 130
				body.apply_impulse(ropeImpulse)
				ropeTempPosition = Vector2(swingRope.global_position.x, global_position.y)
			ropeBottom = body.get_parent().get_node("RopeLinkageBottom")
			ropeTop = body.get_parent().get_node("RopeLinkageTop")
	elif body.name.contains("RopeLinkage") && swingRope != null && !isKicking:
		swingRope = body
		ropeTempPosition = Vector2(swingRope.global_position.x, global_position.y)
		if swingRope.get_parent().name.contains("Static"):
			ropeTempPosition = Vector2(swingRope.global_position.x - 4, global_position.y)
		ropeBottom = body.get_parent().get_node("RopeLinkageBottom")
		ropeTop = body.get_parent().get_node("RopeLinkageTop")
	pass

func use_legs(body):
	if body.name.contains("RopeLinkage") && swingRope == null && !isInElevator:
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
		if (((countHangTime >= 137 * (countBounces + 1) * 4 / 5 && countBounces > 0) || (countHangTime >= 140 && countBounces > 0)) || (countHangTime >= 137 && countBounces == 0)) && !isInWindCurrent && user_prefs.difficulty_dropdown_index != 1:
			isDead = true
		elif countHangTime >= 400 && isInWindCurrent && user_prefs.difficulty_dropdown_index != 1:
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

func check_controls():
	if Input.is_action_just_pressed("ui_left") || Input.is_action_just_pressed("ui_right"):
		if Input.is_key_pressed(KEY_LEFT) || Input.is_key_pressed(KEY_RIGHT):
			lastMoveMethod = "Keyboard"
		else:
			lastMoveMethod = "Controller"
	if Input.is_action_just_pressed("ui_click"):
		if Input.is_key_pressed(KEY_ENTER):
			lastConfirmMethod = "Keyboard"
		else:
			lastConfirmMethod = "Controller"
	if currentMoveMethod != lastMoveMethod || currentConfirmMethod != lastConfirmMethod:
		currentMoveMethod = lastMoveMethod
		currentConfirmMethod = lastConfirmMethod
		changeControls = true
	elif currentMoveMethod == lastMoveMethod  && currentConfirmMethod == lastConfirmMethod && changeControls:
		changeControls = false
	pass

func check_swinging():
	if Input.is_action_just_pressed("swing_leftrow") || Input.is_action_just_pressed("swing_rightrow"):
		lastSwingMethod = "Keyboard"
	elif Input.is_action_just_pressed("swing_left") || Input.is_action_just_pressed("swing_right"):
		lastSwingMethod = "DPAD"
	elif Input.is_action_just_pressed("swing_lb") || Input.is_action_just_pressed("swing_rb"):
		lastSwingMethod = "Bumpers"
	if currentSwingMethod != lastSwingMethod:
		currentSwingMethod = lastSwingMethod
		changeSwinging = true
	elif currentSwingMethod == lastSwingMethod && changeSwinging:
		changeSwinging = false
	pass

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:	
		if user_prefs.difficulty_dropdown_index == 0:
			user_prefs.relaxed_save = global_position
			user_prefs.relaxed_checkpoint = checkpoint
			user_prefs.relaxed_boots_flag = hasNewLegs
			user_prefs.relaxed_rockets_flag = hasRocketJump
			user_prefs.relaxed_jetpack_flag = hasJetpack
			user_prefs.relaxed_fuel_count = countJetpackFuel
			user_prefs.relaxed_macguffin_flag = hasMacguffin
			user_prefs.relaxed_macguffin2_flag = hasMacguffin2
			user_prefs.relaxed_macguffin3_flag = hasMacguffin3
			user_prefs.relaxed_ms = timer.ms
			user_prefs.relaxed_s = timer.s
			user_prefs.relaxed_m = timer.m
			user_prefs.relaxed_h = timer.h
		elif user_prefs.difficulty_dropdown_index == 1:
			user_prefs.foddian_save = global_position
			user_prefs.foddian_checkpoint = checkpoint
			user_prefs.foddian_boots_flag = hasNewLegs
			user_prefs.foddian_rockets_flag = hasRocketJump
			user_prefs.foddian_jetpack_flag = hasJetpack
			user_prefs.foddian_fuel_count = countJetpackFuel
			user_prefs.foddian_macguffin_flag = hasMacguffin
			user_prefs.foddian_macguffin2_flag = hasMacguffin2
			user_prefs.foddian_macguffin3_flag = hasMacguffin3
			user_prefs.foddian_ms = timer.ms
			user_prefs.foddian_s = timer.s
			user_prefs.foddian_m = timer.m
			user_prefs.foddian_h = timer.h
		elif user_prefs.difficulty_dropdown_index == 2:
			user_prefs.permadeath_save = global_position
			user_prefs.permadeath_boots_flag = hasNewLegs
			user_prefs.permadeath_rockets_flag = hasRocketJump
			user_prefs.permadeath_jetpack_flag = hasJetpack
			user_prefs.permadeath_fuel_count = countJetpackFuel
			user_prefs.permadeath_macguffin_flag = hasMacguffin
			user_prefs.permadeath_macguffin2_flag = hasMacguffin2
			user_prefs.permadeath_macguffin3_flag = hasMacguffin3
			user_prefs.permadeath_ms = timer.ms
			user_prefs.permadeath_s = timer.s
			user_prefs.permadeath_m = timer.m
			user_prefs.permadeath_h = timer.h
		user_prefs.save()
		get_tree().quit()
	pass

func save_game():
	if user_prefs.difficulty_dropdown_index == 0:
		user_prefs.relaxed_save = global_position
		user_prefs.relaxed_checkpoint = checkpoint
		user_prefs.relaxed_boots_flag = hasNewLegs
		user_prefs.relaxed_rockets_flag = hasRocketJump
		user_prefs.relaxed_jetpack_flag = hasJetpack
		user_prefs.relaxed_fuel_count = countJetpackFuel
		user_prefs.relaxed_macguffin_flag = hasMacguffin
		user_prefs.relaxed_macguffin2_flag = hasMacguffin2
		user_prefs.relaxed_macguffin3_flag = hasMacguffin3
		user_prefs.relaxed_ms = timer.ms
		user_prefs.relaxed_s = timer.s
		user_prefs.relaxed_m = timer.m
		user_prefs.relaxed_h = timer.h
	elif user_prefs.difficulty_dropdown_index == 1:
		user_prefs.foddian_save = global_position
		user_prefs.foddian_checkpoint = checkpoint
		user_prefs.foddian_boots_flag = hasNewLegs
		user_prefs.foddian_rockets_flag = hasRocketJump
		user_prefs.foddian_jetpack_flag = hasJetpack
		user_prefs.foddian_fuel_count = countJetpackFuel
		user_prefs.foddian_macguffin_flag = hasMacguffin
		user_prefs.foddian_macguffin2_flag = hasMacguffin2
		user_prefs.foddian_macguffin3_flag = hasMacguffin3
		user_prefs.foddian_ms = timer.ms
		user_prefs.foddian_s = timer.s
		user_prefs.foddian_m = timer.m
		user_prefs.foddian_h = timer.h
	elif user_prefs.difficulty_dropdown_index == 2:
		user_prefs.permadeath_save = global_position
		user_prefs.permadeath_boots_flag = hasNewLegs
		user_prefs.permadeath_rockets_flag = hasRocketJump
		user_prefs.permadeath_jetpack_flag = hasJetpack
		user_prefs.permadeath_fuel_count = countJetpackFuel
		user_prefs.permadeath_macguffin_flag = hasMacguffin
		user_prefs.permadeath_macguffin2_flag = hasMacguffin2
		user_prefs.permadeath_macguffin3_flag = hasMacguffin3
		user_prefs.permadeath_ms = timer.ms
		user_prefs.permadeath_s = timer.s
		user_prefs.permadeath_m = timer.m
		user_prefs.permadeath_h = timer.h
	user_prefs.save()
	
