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
	
func _process(delta):
	if bounce.volume_db != %SFXVolumeHandler.SFX_volume:
		bounce.volume_db = %SFXVolumeHandler.SFX_volume
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
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
		body.countHangTime = 0
		body.countRocketJumps = body.maxRocketJumps
		if !hasBeenUsed:
			if !body.hasJetpack:
				body.velocity.y =  -1 * abs(body.velocity.y)
			body.wasBouncing = true
			body.countHangTime = 0
			body.countBounces += 1
			hasBeenUsed = true
	pass # Replace with function body.
