extends RigidBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'del+ta' is the elapsed time since the previous frame.
func _process(_delta):
	if abs(rotation) < 2.35:
		if round(linear_velocity.x) > 0 && round(linear_velocity.x) < 75:
			if abs(linear_velocity.x) < 75 && abs(linear_velocity.x) > 50:
				linear_velocity.x -= (sign(linear_velocity.x) * .1 * abs(linear_velocity.x))
			elif abs(linear_velocity.x) <= 50 && abs(linear_velocity.x) > 5:
				linear_velocity.x -= (sign(linear_velocity.x) * .15 * abs(linear_velocity.x))
			elif abs(linear_velocity.x) <= 5:
				linear_velocity.x = 0
	pass
