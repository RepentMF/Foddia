extends Node2D

@onready var anim = $AnimatedSprite2D

var hasBeenUsed = false
var placement = false
var countTime = 0 
var countTime2 = 0
var countTime3 = 0

# Called when the node enters the scene tree for the first time.
#func _ready():
#	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	print(anim.animation)
	# Player has hit button
	if hasBeenUsed:
		get_node("ElevatorWall1").process_mode = Node.PROCESS_MODE_INHERIT
		get_node("ElevatorWall2").process_mode = Node.PROCESS_MODE_INHERIT
		# Doors have not closed yet
		if countTime2 == 0:
			anim.play("door_closing")
			countTime2 += 1
		elif countTime2 < 80:
			get_node("ElevatorWall1").global_position.y += 1
			get_node("ElevatorWall2").global_position.y += 1
			countTime2 += 1
			if anim.animation == "door_closing" && anim.frame == 6:
				anim.pause()
		# Doors have closed
		elif countTime2 == 80:
			# Elevator has not reached destination yet
			if countTime < 2645: #3104
				anim.play("door_closed")
				countTime += 1
				if placement:
					position.y += 7
				else:
					position.y -= 7
			# Elevator has reached destination
			elif countTime == 2645:
				print("Thank you for riding with us. We hope you enjoyed your time.")
				if countTime3 == 0:
					anim.play("door_opening")
					countTime3 += 1
				elif countTime3 < 80:
					get_node("ElevatorWall1").global_position.y -= 1
					get_node("ElevatorWall2").global_position.y -= 1
					countTime3 += 1
					if anim.animation == "door_opening" && anim.frame == 6:
						anim.pause()
				elif countTime3 == 80:
					hasBeenUsed = false
					countTime = 0
					countTime2 = 0
					countTime3 = 0
					if placement:
						placement = false
					else:
						placement = true
	else:
		get_node("ElevatorWall1").process_mode = Node.PROCESS_MODE_DISABLED
		get_node("ElevatorWall2").process_mode = Node.PROCESS_MODE_DISABLED
		anim.play("door_open")
	pass

func _on_area_2d_body_entered(body):
	hasBeenUsed = true
	pass # Replace with function body.
