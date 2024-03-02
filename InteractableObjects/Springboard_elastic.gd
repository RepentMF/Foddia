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
		print(body.velocity.y)
		if !hasBeenUsed:
			if !body.hasJetpack:
				body.velocity.y =  -1 * abs(body.velocity.y)
			body.wasBouncing = true
			body.countHangTime = 0
			hasBeenUsed = true
	pass # Replace with function body.
