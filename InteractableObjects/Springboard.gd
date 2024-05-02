extends Area2D

@onready var anim = $AnimatedSprite2D

const InitialTime = 30

var hasBeenUsed = false
var countTime = 30

# Called when the node enters the scene tree for the first time.
#func _ready():
#	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if hasBeenUsed:
		if countTime > 0:
			if countTime == InitialTime:
				anim.play("bounce")
			countTime -= 1
		elif countTime <= 0:
			hasBeenUsed = false
			countTime = InitialTime
	pass

func _on_body_entered(body):
	if body.name == "Player":
		body.countRocketJumps = body.maxRocketJumps
		if !hasBeenUsed:
			if !body.hasJetpack:
				if snappedf(rotation, 0.01) == 1.57:
					body.velocity.x = -1.1 * body.velocity.x
					body.velocity.y = 0
				elif rotation == 0:
					print(body.countHangTime, " ", body.velocity.x)
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
			hasBeenUsed = true
	pass # Replace with function body.
