extends Area2D

var airCount = 0
var count = 0
var fadeInPanel
var player

# Called when the node enters the scene tree for the first time.
#func _ready():
#	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if player != null:
			if player.position.y < -25031:
				airCount += 1
				fadeInPanel.visible = true
			if airCount > 1000:
				if count % 10 == 0 && fadeInPanel.color.a < 1:
					count += 1
					fadeInPanel.color.a += 0.1
				elif fadeInPanel.color.a > 0:
					count += 1
				elif fadeInPanel.color.a <= 0:
					fadeInPanel.color.a = 1
				if airCount > 1100 && fadeInPanel.color.a >= 1:
					get_tree().change_scene_to_file("res://Menus/SpaceEnding.tscn")
	pass

func _on_body_entered(body):
	if body.name == "Player":
		body.isInZeroG = true
		player = body
		fadeInPanel = %FadeInPanel
		fadeInPanel.color = Color(0, 0, 0, 0)
	pass # Replace with function body.


func _on_body_exited(body):
	if body.name == "Player":
		body.isInZeroG = false
		airCount = 0
		body = null
		fadeInPanel.color = Color(0, 0, 0, 0)
		fadeInPanel.visible = false
	pass # Replace with function body.
