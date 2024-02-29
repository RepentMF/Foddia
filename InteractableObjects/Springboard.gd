extends Area2D

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
				countTime -= 1
		elif countTime <= 0:
			hasBeenUsed = false
			countTime = InitialTime
	pass

func _on_body_entered(body):
	if body.name == "Player":
		if !hasBeenUsed:
			if !body.hasJetpack:
				if snappedf(rotation, 0.01) == 1.57:
					print("90 degrees")
					body.velocity.x = -1.1 * body.velocity.x
					body.velocity.y = 0
				elif rotation == 0:
					print("0 degrees")
					body.velocity.x = 1.15 * body.velocity.x
					body.velocity.y = -2 * body.jumpSpeed
					if body.countHangTime > 60 && abs(body.velocity.x) < 200:
						# Needs to be a multiple that gets the player back to as high as they previously were
						# Last worked on 2/28/2024
						body.velocity.y = 2.29 * body.velocity.y
				elif rotation > 0 && snappedf(rotation, 0.01) < 1.57:
					print("1 degree to 89 degrees")
					body.velocity.x = 1.25 * abs(body.velocity.x)
					body.velocity.y = -2 * body.jumpSpeed
					if body.countHangTime > 60 && abs(body.velocity.x) < 200:
						body.velocity.y = 2.75 * body.velocity.y
				elif rotation < 0 && snappedf(rotation, 0.01) > -1.57:
					print("-1 degree to -89 degrees")
					body.velocity.x = -1.25 * abs(body.velocity.x)
					body.velocity.y = -2 * body.jumpSpeed
					if body.countHangTime > 60 && abs(body.velocity.x) < 200:
						body.velocity.y = 2.75 * body.velocity.y
				if body.velocity.x == 0:
					print("softlock prevention")
					body.velocity.x = 20
			print(body.velocity.y)
			print(body.countHangTime)
			body.wasBouncing = true
			body.countHangTime = 0
			hasBeenUsed = true
	pass # Replace with function body.
