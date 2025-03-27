extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !%Elevator.hasBeenUsed:
		get_node("AnimatedSprite2D").animation = "off"
	elif %Elevator.speed == 7:
		get_node("AnimatedSprite2D").animation = "down"
	elif %Elevator.speed == -7:
		get_node("AnimatedSprite2D").animation = "up"
	pass

func _on_body_entered(body):
	if body.name == "Player" && %Elevator.countTime != 2645:
		print(body.isInElevator, ", ", %Elevator.countTime, ", ", %Elevator.countTime2, ", ", %Elevator.countTime3, ", ", %Elevator.hasBeenUsed)
		%Elevator.hasBeenUsed = true
		if %Elevator.countTime > 0 && !(%Elevator.anim.animation == "door_closing" && %Elevator.anim.frame == 6):
			%Player.get_node("AudioPlayer").switched.play()
			%Elevator.countTime = 2645 - %Elevator.countTime
			if %Elevator.placement:
				%Elevator.placement = false
			else:
				%Elevator.placement = true
	pass # Replace with function body.
