extends Node2D

var oof_setter
var player

# Called when the node enters the scene tree for the first time.
func _ready():
	oof_setter = false
	player = get_parent()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player.countHangTime > 1190:
		oof_setter = true
	if oof_setter && player.velocity.y == 0:
		if !Steam.getAchievement("ACHIEVEMENT_OOF")["achieved"]:
			Steam.setAchievement("ACHIEVEMENT_OOF")
	pass
