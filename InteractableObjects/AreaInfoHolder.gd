extends Area2D

var areaName
var songName

var count = 120
var keepChecking = false

# Called when the node enters the scene tree for the first time.
func _ready():
	areaName = get_meta("AreaName")
	songName = get_meta("SongName")
	pass # Replace with function body.

func _physics_process(delta):
	if keepChecking && !%Player.isInElevator:
		count -= 1
		for n in get_overlapping_bodies():
			if n.name == "Player":
				assign_info(n)
				keepChecking = false
		if count <= 0:
			count = 120
			keepChecking = false
	pass

func assign_info(body):
	%AreaTitleCard.current_string = areaName
	body.get_node("RadioPlayer").current_string = songName
	body.areaName = areaName
	if %UserPrefsController.user_prefs.difficulty_dropdown_index == 0:
		%UserPrefsController.user_prefs.rel_last_area = areaName
		%UserPrefsController.user_prefs.rel_last_song = songName
	elif %UserPrefsController.user_prefs.difficulty_dropdown_index == 1:
		%UserPrefsController.user_prefs.fod_last_area = areaName
		%UserPrefsController.user_prefs.fod_last_song = songName
	elif %UserPrefsController.user_prefs.difficulty_dropdown_index == 2:
		%UserPrefsController.user_prefs.per_last_area = areaName
		%UserPrefsController.user_prefs.per_last_song = songName
	if areaName == "?????" || areaName.contains("Pandemonium"):
		if !%HelllightRed.visible:
			%HelllightRed.visible = true
			%HelllightRed2.visible = true
			%HelllightBlack.visible = true
	%UserPrefsController.user_prefs.save()
	pass

func _on_body_entered(body):
	if body.name == "Player":
		if !body.game_start:
			if (body.countHangTime < 100 && abs(body.velocity.y) < 200 && !body.isInElevator) || body.isHoldingRope:
				assign_info(body)
			else:
				keepChecking = true
	pass # Replace with function body.
