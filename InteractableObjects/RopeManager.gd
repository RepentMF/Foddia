extends RigidBody2D

@onready var player = get_tree().root.get_node("Overworld/Player")

# Called when the node enters the scene tree for the first time.
func _ready():
	collision_layer = 2
	collision_mask = 2
	pass # Replace with function body.

# Called every frame. 'del+ta' is the elapsed time since the previous frame.
func _process(_delta):
	# This will fix the rope if ever it gets tangled on itself, praise the Lord omg
	if abs(rotation) > 2.5 && player.climbCount > 1:
		collision_layer = 4
		collision_mask = 4
	elif collision_layer != 2:
		collision_layer = 2
		collision_mask = 2
	slow_rope()
	pass

# Slow down the rope just like the demo (I was limiting previous iterations of this function
# to only when the rope was above a certain amount of velocity.x, but now it just runs all the
# time :)
func slow_rope():
	if abs(linear_velocity.x) < 200 && abs(linear_velocity.x) >= 50:
		linear_velocity.x -= (sign(linear_velocity.x) * .1 * abs(linear_velocity.x))
	elif abs(linear_velocity.x) < 50 && abs(linear_velocity.x) >= 25:
		linear_velocity.x -= (sign(linear_velocity.x) * .125 * abs(linear_velocity.x))
	elif abs(linear_velocity.x) < 25 && abs(linear_velocity.x) >= 0:
		linear_velocity.x -= (sign(linear_velocity.x) * .15 * abs(linear_velocity.x))
	pass

func print_values(string):
	if get_parent().name == "SwingingRope8" && get_parent().get_parent().name == "Area3_ropes":
		print(string)
	pass
