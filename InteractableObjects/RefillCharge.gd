extends Area2D

var temp_volume

@onready var anim = $AnimatedSprite2D

const InitialTime = 120

var hasBeenUsed = false
var countTime = 120

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if temp_volume != %SFXVolumeHandler.SFX_volume:
		temp_volume = %SFXVolumeHandler.SFX_volume
		get_node("Refill").volume_db = temp_volume
	if anim.animation == "break" && anim.frame == 4:
		anim.play("used")
	elif hasBeenUsed && !anim.animation == "break" && !anim.animation == "used" && countTime >= 110:
		anim.play("break")
	elif hasBeenUsed && anim.animation == "used"  && anim.animation != "combine" && countTime <= 15:
		anim.play("combine")
	elif !hasBeenUsed:
		anim.play("idle")
	
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
				body.rocket1.modulate = Color(1, 1, 1, 1)
				body.rocket2.modulate = Color(1, 1, 1, 1)
				body.countJetpackFuel = body.maxJetpackFuel
				hasBeenUsed = true
			if !get_node("Refill").is_playing():
				get_node("Refill").play()
			elif get_node("Refill").get_playback_position() > get_node("Refill").stream.get_length() - 0.05:
				get_node("Refill").stop()
				get_node("Refill").play()
	pass # Replace with function body.
