extends Node2D

var count = 180
var willFall = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if willFall:
		if count > 0:
			count -= 1
		elif count == 0:
			for i in get_parent().get_children():
				if i.name.contains("RopeLinkage"):
					i.gravity_scale = 0.3
			get_parent().get_node("RopeLinkageTop").freeze = false
			get_parent().get_node("RopeLinkageTop").hasFallen = true
			queue_free()
	pass
