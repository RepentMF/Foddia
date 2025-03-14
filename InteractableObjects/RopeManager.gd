extends RigidBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'del+ta' is the elapsed time since the previous frame.
func _process(_delta):
	if get_parent().player.swingRope != null:
		if get_parent().player.swingRope.get_parent() == get_parent():
			if round(linear_velocity.x) > 0 && round(linear_velocity.x) < 200:
				#if abs(linear_velocity.x) < 200 && abs(linear_velocity.x) >= 100:
				#	linear_velocity.x -= (sign(linear_velocity.x) * .125 * abs(linear_velocity.x))
				if abs(linear_velocity.x) < 100 && abs(linear_velocity.x) >= 50:
					linear_velocity.x -= (sign(linear_velocity.x) * .15 * abs(linear_velocity.x))
				elif abs(linear_velocity.x) < 50 && abs(linear_velocity.x) >= 25:
					linear_velocity.x -= (sign(linear_velocity.x) * .2 * abs(linear_velocity.x))
				elif abs(linear_velocity.x) < 25 && abs(linear_velocity.x) >= 5:
					linear_velocity.x -= (sign(linear_velocity.x) * .3 * abs(linear_velocity.x))
				elif abs(linear_velocity.x) <= 5:
					linear_velocity.x = 0
	pass
