extends Node2D

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
	# Player has hit button
	if hasBeenUsed:
		# Doors have not closed yet
		if countTime2 < 80:
			get_node("ElevatorWall1").global_position.y += 1
			get_node("ElevatorWall2").global_position.y += 1
			countTime2 += 1
		# Doors have closed
		elif countTime2 == 80:
			# Elevator has not reached destination yet
			if countTime < 2644: #3104
				print("Elevator in use!")
				countTime += 1
				if placement:
					position.y += 7
				else:
					position.y -= 7
			# Elevator has reached destination
			elif countTime == 2644:
				print("Thank you for riding with us. We hope you enjoyed your time.")
				if countTime3 < 80:
					get_node("ElevatorWall1").global_position.y -= 1
					get_node("ElevatorWall2").global_position.y -= 1
					countTime3 += 1
				elif countTime3 == 80:
					hasBeenUsed = false
					countTime = 0
					countTime2 = 0
					countTime3 = 0
					if placement:
						placement = false
					else:
						placement = true
	pass

func _on_area_2d_body_entered(body):
	hasBeenUsed = true
	pass # Replace with function body.
