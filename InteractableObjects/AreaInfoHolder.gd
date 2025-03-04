extends Area2D

var user_prefs: UserPreferences

var areaName
var songName

# Called when the node enters the scene tree for the first time.
func _ready():
	user_prefs = UserPreferences.load_or_create()
	areaName = get_meta("AreaName")
	songName = get_meta("SongName")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_body_entered(body):
	if body.name == "Player":
		if !body.game_start:
			if (body.countHangTime < 100 && abs(body.velocity.y) < 200 && !body.isInElevator) || body.isHoldingRope:
				%AreaTitleCard.current_string = areaName
				body.get_node("RadioPlayer").current_string = songName
				body.areaName = areaName
				if user_prefs.difficulty_dropdown_index == 0:
					user_prefs.rel_last_area = areaName
					user_prefs.rel_last_song = songName
				elif user_prefs.difficulty_dropdown_index == 1:
					user_prefs.fod_last_area = areaName
					user_prefs.fod_last_song = songName
				elif user_prefs.difficulty_dropdown_index == 2:
					user_prefs.per_last_area = areaName
					user_prefs.per_last_song = songName
				if areaName == "?????" || areaName.contains("Pandemonium"):
					if !%HelllightRed.visible:
						%HelllightRed.visible = true
						%HelllightRed2.visible = true
						%HelllightBlack.visible = true
				user_prefs.save()
	pass # Replace with function body.
