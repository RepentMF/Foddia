extends AnimatedSprite2D

var openPhone = false
var start = false
var stopVar = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if %RadioInfo.newSong && (%AreaTitleCard.fadeOutCount == %AreaTitleCard.fadeOutMax - 1 || %AreaTitleCard.fadeOutCount == %AreaTitleCard.fadeOutMax - 2):
		start = true
	
	if start && !%Player.isInteracting:
		if openPhone && !%Radio_fg.visible && animation != "open_phone":
			play("open_phone")
			openPhone = false
		elif animation == "open_phone" && frame > 8:
			stop()
			visible = false
			%Radio_fg.visible = true
			%Radio_bg.visible = true
			%RadioMover.visible = true
			%RadioMover.move = true
			start = false
		
		if position.y > 624:
			position.y -= 4
		elif position.y <= 624 && !%RadioInfo.stop:
			openPhone = true
		
	if %RadioInfo.stop && %Radio_fg.visible && animation != "close_phone":
		play("close_phone")
		visible = true
		%Radio_fg.visible = false
		%RadioMover.visible = false
		%RadioMover.move = false
	elif animation == "close_phone" && frame > 1 && frame < 4:
		%Radio_bg.visible = false
	elif animation == "close_phone" && frame > 8:
		play("idle")
		stopVar = true
	
	if position.y < 752 && stopVar:
		position.y += 4
	elif position.y >= 752 && stopVar:
		stopVar = false
		openPhone = false
		start = false
		%RadioInfo.stop = false
		%RadioInfo.blankCount = 0
		%RadioInfo.removeChar = false
		%RadioInfo.count = 0
		%RadioInfo.blankString = ""
		%RadioInfo.newSong = false
		%RadioInfo.removeCount = 0
		%RadioInfo.songData = ""
		%RadioInfo.tempString = ""
		%RadioInfo.visible_characters = 0
		%RadioMover.move = false
	pass
