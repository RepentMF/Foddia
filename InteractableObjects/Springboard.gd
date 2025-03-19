extends Area2D

@onready var anim = $AnimatedSprite2D

const InitialTime = 30

var bounce
var countTime = 30
var hasBeenUsed = false
var rng

# Called when the node enters the scene tree for the first time.
func _ready():
	rng = RandomNumberGenerator.new()
	rng.randomize()
	bounce = get_node("Bounce")
	pass # Replace with function body.

func _process(_delta):
	if bounce.volume_db != %SFXVolumeHandler.SFX_volume:
		bounce.volume_db = %SFXVolumeHandler.SFX_volume
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if hasBeenUsed:
		if countTime > 0:
			if countTime == InitialTime:
				anim.play("bounce")
				bounce.pitch_scale = rng.randf_range(.8, 1.2)
				bounce.play(0.1)
			countTime -= 1
		elif countTime <= 0:
			hasBeenUsed = false
			countTime = InitialTime
	pass

func _on_body_entered(body):
	if body.name == "Player":
		body.countRocketJumps = body.maxRocketJumps
		body.countHangTime = 0
		body.dizzy.visible = false
		body.isFreefalling = false
		body.landedSoft = false
		body.landedHard = false
		if !hasBeenUsed:
			if !body.hasJetpack:
				if snappedf(rotation, 0.01) == 1.57:
					body.velocity.x = -1.1 * body.velocity.x
					body.velocity.y = 0
				elif rotation == 0:
					if body.countHangTime >= 55 && abs(body.velocity.x) < 230:
						body.velocity.y =  -1 * body.velocity.y
					else:
						body.velocity.x = 1.15 * body.velocity.x
						body.velocity.y = -2.25 * body.jumpSpeed
				elif rotation > 0 && snappedf(rotation, 0.01) < 1.57:
					if body.countHangTime >= 55 && abs(body.velocity.x) < 230:
						body.velocity.y =  -1 * body.velocity.y
					else:
						body.velocity.x = 1.25 * abs(body.velocity.x)
						body.velocity.y = -2.25 * body.jumpSpeed
				elif rotation < 0 && snappedf(rotation, 0.01) > -1.57:
					if body.countHangTime >= 55 && abs(body.velocity.x) < 230:
						body.velocity.y =  -1 * body.velocity.y
					else:
						body.velocity.x = -1.25 * abs(body.velocity.x)
						body.velocity.y = -2.25 * body.jumpSpeed
				if body.velocity.x == 0:
					body.velocity.x = 20
			body.wasBouncing = true
			body.countHangTime = 0
			body.countBounces += 1
			hasBeenUsed = true
	pass # Replace with function body.
