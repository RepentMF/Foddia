extends Area2D

var hasBeenPickedUp = false
var countTime = 120

# Called when the node enters the scene tree for the first time.
#func _ready():
#	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if hasBeenPickedUp:
		if countTime > 0:
				countTime -= 1
		elif countTime <= 0:
			queue_free()
	pass

func _on_body_entered(body):
	if body.name == "Player":
		if !hasBeenPickedUp:
			hasBeenPickedUp = true
			body.hasJetpack = true
	pass # Replace with function body.
