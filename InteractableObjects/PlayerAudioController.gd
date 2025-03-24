extends Node2D

var temp_volume

var rng
var deadLanded
var dizzy
var hardAir
var hardAir2
var hardAirMax
var hardLanded
var iceSkating
var jetpackPuffed
var jetpackHissed
var jumping
var player
var rocketJumped
var ropeClimbed
var ropeGrabbed
var running
var softAir
var softAirMax
var softLanded
var walking

var dead
var hangCount
var jumpCount
var justGrabbedRope
var justJumped
var justLanded
var landCount
var rocketCount
var ropeCount

func _ready():
	rng = RandomNumberGenerator.new()
	rng.randomize()
	deadLanded = get_node("DeadLanded")
	dizzy = get_node("Dizzy")
	hardAir = get_node("HardAir")
	hardAir2 = get_node("HardAir2")
	hardLanded = get_node("HardLanded")
	iceSkating = get_node("IceSkating")
	jetpackHissed = get_node("JetpackHiss")
	jetpackPuffed = get_node("JetpackPuff")
	jumping = get_node("Jumping")
	player = get_parent()
	rocketJumped = get_node("RocketJumped")
	ropeClimbed = get_node("RopeClimbed")
	ropeGrabbed = get_node("RopeGrabbed")
	running = get_node("Running")
	softAir = get_node("SoftAir")
	softLanded = get_node("SoftLanded")
	walking = get_node("Walking")
	
	dead = false
	hangCount = 0
	jumpCount = 0
	justGrabbedRope = false
	justJumped = false
	rocketCount = 2
	ropeCount = 0
	
	change_all_volumes()
	pass

func _process(_delta):
	if temp_volume != get_tree().root.get_node("Overworld").get_node("SFXVolumeHandler").SFX_volume:
		temp_volume = get_tree().root.get_node("Overworld").get_node("SFXVolumeHandler").SFX_volume
		change_all_volumes()
	
	if player.isHoldingRope || player.is_on_floor() || player.wasBouncing || player.isGrabbingLedge:
		hangCount = 0
		softAir.stop()
		softAir.volume_db = temp_volume - 10
		hardAir.stop()
		hardAir.volume_db = temp_volume - 15
		hardAir2.stop()
		hardAir2.volume_db = temp_volume - 15
	pass

func _physics_process(_delta):
	if player.isInteracting:
		deadLanded.stop()
		hardLanded.stop()
		jumping.stop()
		rocketJumped.stop()
		ropeClimbed.stop()
		ropeGrabbed.stop()
		running.stop()
		softLanded.stop()
		walking.stop()
	if player.countRocketJumps == player.maxRocketJumps:
		rocketCount = 2

	if player.wasJumping:
		jumpCount += 1
	else:
		jumpCount = 0
	
	if player.isHoldingRope:
		ropeCount += 1
	else:
		ropeCount = 0
	
	if player.landedSoft || player.landedHard:
		landCount += 1
	else:
		landCount = 0
	
	if jumpCount == 1:
		justJumped = true
	else:
		justJumped = false
	
	if landCount == 1:
		justLanded = true
	else:
		justLanded = false
	
	if ropeCount == 1:
		justGrabbedRope = true
	else:
		justGrabbedRope = false
	
	if player.isJetpacking:
		if !jetpackHissed.is_playing():
			jetpackHissed.play()
		if !jetpackPuffed.is_playing():
			jetpackPuffed.play()
	elif !player.isJetpacking:
		jetpackPuffed.stop()
		jetpackHissed.stop()
	
	if !walking.is_playing() && player.is_on_floor() && abs(player.velocity.x) < 126 && abs(player.velocity.x) > 0 && !player.isAgainstWall:
		walking.pitch_scale = rng.randf_range(1.0, 1.2)
		walking.play(0.09)
	elif !player.is_on_floor() || !abs(player.velocity.x) > 0 || player.isAgainstWall:
		walking.stop()
		
	if player.isRunning && !running.is_playing() && player.is_on_floor() && abs(player.velocity.x) > 125 && !player.isAgainstWall:
		walking.stop()
		running.pitch_scale = rng.randf_range(1.0, 1.2)
		running.play(0)
	elif abs(player.velocity.x) < 126 || !player.is_on_floor() || !abs(player.velocity.x) > 0 || player.isAgainstWall:
		running.stop()
	
	if justJumped && !jumping.is_playing():
		jumping.pitch_scale = rng.randf_range(.8, 1.2)
		jumping.play(0.06)
	
	if player.countRocketJumps == rocketCount - 1:
		rocketJumped.pitch_scale = rng.randf_range(.9, 1.3)
		rocketJumped.play(0.06)
		rocketCount = player.countRocketJumps
	
	if justGrabbedRope && !ropeGrabbed.is_playing():
		ropeGrabbed.pitch_scale = rng.randf_range(1.0, 1.5)
		ropeGrabbed.play(0)
	
	if player.swingRope != null:
		ropeClimbed.pitch_scale = rng.randf_range(1.0, 1.5)
		if (!player.isKicking || player.swingRope.get_parent().name.contains("Static")) && !player.is_on_floor() && (Input.is_action_pressed("ui_up") || Input.is_action_pressed("ui_down")):
			if  Input.is_action_pressed("ui_up") && !ropeClimbed.is_playing():
				ropeClimbed.play(0)
			elif Input.is_action_pressed("ui_down") && !ropeClimbed.is_playing():
				ropeClimbed.play(0)
		elif ropeClimbed.is_playing() || !player.isHoldingRope:
			ropeClimbed.stop()
			ropeGrabbed.stop()
			ropeCount = 0
	else:
		if ropeClimbed.is_playing() || !player.isHoldingRope:
			ropeClimbed.stop()
			ropeGrabbed.stop()
			ropeCount = 0
	
	if !player.isInElevator && !player.isInZeroG:
		if player.countHangTime > 49 && player.countHangTime == hangCount:
			softAir.play(.81)
		elif player.countHangTime > 49 && hangCount == 0:
			hangCount = player.countHangTime + 1
		elif hangCount != 0:
			if softAir.volume_db < softAirMax:
				softAir.volume_db += 0.02
			if player.countHangTime > 300 && !hardAir.is_playing():
				hardAir.play(.05)
				if hardAir.volume_db < hardAirMax:
					hardAir.volume_db = softAir.volume_db - 2.0
			if player.countHangTime > 300 && hardAir.get_playback_position() > 1.69566671 && !hardAir2.is_playing():
				hardAir2.play(.05)
				if hardAir.volume_db < hardAirMax:
					hardAir2.volume_db = softAir.volume_db - 2.0
	
	if (justLanded && !softLanded.is_playing() && !hardLanded.is_playing()) || player.forceDied:
		if (player.landedHard && dead) || player.forceDied:
			deadLanded.pitch_scale = rng.randf_range(.9, 1.2)
			deadLanded.play(0)
			dead = false
			player.forceDied = false
		elif player.landedHard:
			hardLanded.pitch_scale = rng.randf_range(.9, 1.2)
			hardLanded.play(0)
		elif player.landedSoft:
			softLanded.pitch_scale = rng.randf_range(.9, 1.2)
			softLanded.play(0)
	pass

func change_all_volumes():
	deadLanded.volume_db = temp_volume
	dizzy.volume_db = temp_volume
	hardLanded.volume_db = temp_volume
	iceSkating.volume_db = temp_volume
	jumping.volume_db = temp_volume
	rocketJumped.volume_db = temp_volume
	ropeClimbed.volume_db = temp_volume
	ropeGrabbed.volume_db = temp_volume
	running.volume_db = temp_volume
	softLanded.volume_db = temp_volume
	walking.volume_db = temp_volume
	softAirMax = temp_volume
	hardAirMax = temp_volume
	pass

func _on_dizzy_finished() -> void:
	dizzy.pitch_scale = rng.randf_range(.9, 1.1)
	pass # Replace with function body.

func _on_ice_skating_finished() -> void:
	iceSkating.pitch_scale = rng.randf_range(1.2, 1.4)
	pass # Replace with function body.
