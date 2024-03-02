extends Area2D

const InitialTime = 120

var hasBeenUsed = false
var countTime = 120

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
			if !body.hasRocketJump && !body.hasJetpack:
				body.velocity.y = -2 * body.jumpSpeed
			elif body.hasRocketJump || body.hasJetpack:
				body.countRocketJumps = body.maxRocketJumps
				body.countJetpackFuel = body.maxJetpackFuel
			hasBeenUsed = true
	pass # Replace with function body.
