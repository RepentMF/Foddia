extends Node2D

@onready var player = %Player

# Called when the node enters the scene tree for the first time.
func _ready():
	global_position = player.global_position
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if !player.game_start:
		if %CamMesh.camLocked:
			global_position = player.global_position
			%CamMesh.temp_posX = global_position.x
			%CamMesh.temp_posY = global_position.y
		else:
			global_position = %CamMesh.global_position
	pass
