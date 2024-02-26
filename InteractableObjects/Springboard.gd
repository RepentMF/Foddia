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
				if !body.wasBounced && rotation != 0:
					print("a")
					body.wasBounced = true
					body.velocity.x = -1.2 * body.velocity.x
					body.velocity.y = -2 * body.jumpSpeed
				elif body.wasBounced || rotation == 0:
					print("b")
					body.velocity.x = 1.2 * body.velocity.x
					body.velocity.y = -2 * body.jumpSpeed
				if body.velocity.x == 0:
					body.velocity.x = 20
			hasBeenUsed = true
	pass # Replace with function body.
