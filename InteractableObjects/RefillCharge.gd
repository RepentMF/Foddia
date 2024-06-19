extends Area2D

@onready var anim = $AnimatedSprite2D

const InitialTime = 120

var hasBeenUsed = false
var countTime = 120

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if anim.animation == "break" && anim.frame == 4:
		anim.play("used")
	elif hasBeenUsed && !anim.animation == "break" && !anim.animation == "used" && countTime != 0:
		anim.play("break")
	elif hasBeenUsed && anim.animation == "used" && countTime == 5:
		anim.play("combine")
	elif !hasBeenUsed:
		anim.play("idle")
	pass

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
			#if !body.hasRocketJump && !body.hasJetpack:
			#	body.velocity.y = -2 * body.jumpSpeed
			if body.hasRocketJump || body.hasJetpack:
				body.countRocketJumps = body.maxRocketJumps
				body.countJetpackFuel = body.maxJetpackFuel
			hasBeenUsed = true
	pass # Replace with function body.
