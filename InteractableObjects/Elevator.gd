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
	
	if hasBeenUsed:
		if countTime2 < 80:
			get_node("ElevatorWall1").global_position.y += 1
			get_node("ElevatorWall2").global_position.y += 1
			countTime2 += 1
		elif countTime2 == 80:
			if countTime < 3104: #4136
				countTime += 1
				if placement:
					position.y += 7
				else:
					position.y -= 7
			elif countTime == 3104:
				print(global_position.x)
				print(global_position.y)
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
