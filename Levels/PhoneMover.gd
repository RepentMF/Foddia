extends AnimatedSprite2D

var closePhone = false
var current_string = ""
var openPhone = false
var start = false
var stopPhone = false
var stopVar = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if start:
		visible = true
		if position.y >= 555:
			position.y -= 4
		elif position.y <= 555:
			openPhone = true
	elif stopPhone:
		if position.y <= 752:
			position.y += 4
		elif position.y >= 752:
			stopPhone = false
	if openPhone:
		play("open_phone")
	if closePhone:
		play("close_phone")
		visible = true
		%Radio_fg.visible = false
		%Radio_bg.visible = false
		%RadioInfo.visible = false
	pass


func _on_animation_finished():
	if animation == "open_phone":
		stop()
		openPhone = false
		start = false
		visible = false
		%Radio_fg.visible = true
		%Radio_bg.visible = true
		%RadioInfo.change_songs()
	elif animation == "close_phone":
		stop()
		closePhone = false
		stopPhone = true
		play("idle")
	pass # Replace with function body.
