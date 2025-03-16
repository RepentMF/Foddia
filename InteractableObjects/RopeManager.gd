extends RigidBody2D

@onready var player = get_tree().root.get_node("Overworld/Player")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'del+ta' is the elapsed time since the previous frame.
func _process(_delta):
	#if abs(round(linear_velocity.x)) >= 5 && round(linear_velocity.x) < 200:
	#	slow_rope()
	#elif abs(round(linear_velocity.x)) < 3 && round(linear_velocity.x) != 0:
	#	get_parent().get_node("RopeLinkageBottom").linear_velocity.x = 0
	if round(linear_velocity.x) > 0:
		if player.swingRope != null:
			if player.swingRope.get_parent() == get_parent():
				if player.isKicking && player.swingRope == self:
					very_slow_rope()
				else:
					slow_rope()
			else:
				slow_rope()
		else:
			slow_rope()
	pass

func slow_rope():
	if abs(linear_velocity.x) < 200 && abs(linear_velocity.x) >= 50:
		linear_velocity.x -= (sign(linear_velocity.x) * .1 * abs(linear_velocity.x))
	elif abs(linear_velocity.x) < 50 && abs(linear_velocity.x) >= 25:
		linear_velocity.x -= (sign(linear_velocity.x) * .125 * abs(linear_velocity.x))
	elif abs(linear_velocity.x) < 25 && abs(linear_velocity.x) >= 0:
		linear_velocity.x -= (sign(linear_velocity.x) * .15 * abs(linear_velocity.x))
	pass

func very_slow_rope():
	print("here")
	#linear_velocity.x = get_parent().get_node("RopeLinkage10").linear_velocity.x
