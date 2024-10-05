extends Node2D

var rng
var deadLanded
var hardAir
var hardAir2
var hardLanded
var jumping
var player
var rocketJumped
var ropeClimbed
var ropeGrabbed
var running
var softAir
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
	hardAir = get_node("HardAir")
	hardAir2 = get_node("HardAir2")
	hardLanded = get_node("HardLanded")
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
	pass

func _physics_process(delta):
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
	
	if !walking.is_playing() && player.is_on_floor() && abs(player.velocity.x) < 126 && abs(player.velocity.x) > 0:
		walking.pitch_scale = rng.randf_range(1.0, 1.2)
		walking.play(0.09)
	elif !player.is_on_floor() || !abs(player.velocity.x) > 0:
		walking.stop()
		
	if player.isRunning && !running.is_playing() && player.is_on_floor() && abs(player.velocity.x) > 125:
		walking.stop()
		running.pitch_scale = rng.randf_range(1.0, 1.2)
		running.play(0)
	elif abs(player.velocity.x) < 126 || !player.is_on_floor() || !abs(player.velocity.x) > 0:
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
		if player.isHoldingRope && player.swingRope.get_parent().name.contains("Static") && !ropeClimbed.is_playing && (Input.is_action_pressed("ui_up") || Input.is_action_pressed("ui_down")):
			ropeClimbed.play(0)
		elif ropeCount == 0 || (Input.is_action_pressed("ui_up") || Input.is_action_pressed("ui_down")):
			ropeClimbed.stop()
			ropeCount = 0
	
	if player.countHangTime > 49 && player.countHangTime == hangCount && !player.isInZeroG:
		softAir.play(.81)
	elif player.countHangTime > 49 && hangCount == 0:
		hangCount = player.countHangTime + 1
	elif hangCount != 0:
		softAir.volume_db += 0.02
		if player.countHangTime > 300 && !hardAir.is_playing():
			hardAir.play(.05)
			hardAir.volume_db = softAir.volume_db - 2.0
		if player.countHangTime > 300 && hardAir.get_playback_position() > 1.69566671 && !hardAir2.is_playing():
			hardAir2.play(.05)
			hardAir2.volume_db = softAir.volume_db - 2.0
	
	if justLanded && !softLanded.is_playing() && !hardLanded.is_playing():
		if player.landedHard && dead:
			deadLanded.pitch_scale = rng.randf_range(.9, 1.2)
			deadLanded.play(0)
			dead = false
		elif player.landedHard:
			hardLanded.pitch_scale = rng.randf_range(.9, 1.2)
			hardLanded.play(0)
		elif player.landedSoft:
			softLanded.pitch_scale = rng.randf_range(.9, 1.2)
			softLanded.play(0)
	
	if player.isHoldingRope || player.is_on_floor() || player.wasBouncing:
		hangCount = 0
		softAir.stop()
		softAir.volume_db = -10
		hardAir.stop()
		hardAir.volume_db = -10
		hardAir2.stop()
		hardAir2.volume_db = -10
	pass
