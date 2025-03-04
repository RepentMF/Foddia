extends Area2D

@onready var tilemap = $TileMap
var hasBeenEntered = false
var countTime = 0 
var countTime2 = 0
var countTime3 = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if hasBeenEntered && tilemap.modulate.a > 0:
		tilemap.modulate.a -= .03
	elif !hasBeenEntered && tilemap.modulate.a < 1 && name.contains("TheJort"):
		tilemap.modulate.a += .03
	elif tilemap.modulate.a <= 0:
		if !name.contains("TheJort"):
			queue_free()
	pass

func _on_area_2d_body_entered(body):
	if body.name == "Player":
		hasBeenEntered = true
	pass # Replace with function body.


func _on_area_2d_body_exited(body):
	if body.name == "Player" && name.contains("TheJort"):
		hasBeenEntered = false
	pass # Replace with function body.
