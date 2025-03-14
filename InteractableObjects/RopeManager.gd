extends RigidBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'del+ta' is the elapsed time since the previous frame.
func _process(_delta):
	if abs(round(linear_velocity.x)) >= 5 && round(linear_velocity.x) < 200:
		slow_rope()
	elif abs(round(linear_velocity.x)) < 3 && round(linear_velocity.x) != 0:
		get_parent().get_node("RopeLinkageBottom").linear_velocity.x = 0
	pass

func slow_rope():
	if abs(linear_velocity.x) < 200 && abs(linear_velocity.x) >= 50:
		linear_velocity.x -= (sign(linear_velocity.x) * .2 * abs(linear_velocity.x))
	elif abs(linear_velocity.x) < 50 && abs(linear_velocity.x) >= 25:
		linear_velocity.x -= (sign(linear_velocity.x) * .25 * abs(linear_velocity.x))
	elif abs(linear_velocity.x) < 25 && abs(linear_velocity.x) >= 5:
		linear_velocity.x -= (sign(linear_velocity.x) * .3 * abs(linear_velocity.x))
	pass
