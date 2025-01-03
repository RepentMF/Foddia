extends Node2D

var user_prefs: UserPreferences

var album
var audio_changeable
var current
var current_rand
var commercialIsPlaying
var max_volume
var player
var radio_sound
var radio_sound_bool
var radio_static
var rand_num
var rng
var selected
var song1
var song2
var song3
var song4
var song5
var song6
var song7
var song8
var songIsPlaying
var staticIsPlaying

func _ready():
	user_prefs = UserPreferences.load_or_create()
	audio_changeable = false
	player = get_parent()
	radio_sound = false
	radio_sound_bool = true
	radio_static = get_node("RadioStatic")
	rng = RandomNumberGenerator.new()
	rng.randomize()
	song1 = get_node("LostAgain")
	song2 = get_node("DontLookDown")
	song3 = get_node("TestofPatience")
	song4 = get_node("TrialsAbound")
	song5 = get_node("CantTurnBack")
	song6 = get_node("MaytheStarsFollowYou")
	song7 = get_node("PainfulLonging")
	song8 = get_node("GnawingDesires")
	songIsPlaying = false
	staticIsPlaying = false
	
	album = [song1, song2, song3, song4, song5, song6, song7, song8]
	pass

func _physics_process(delta):
	max_volume = change_volume(user_prefs.music_audio_level)
		
	if current != selected || current == null:
		if current != null:
			if songIsPlaying:
				album[current].volume_db -= 1
				if album[current].volume_db <= -60:
					album[current].stop()
					songIsPlaying = false
					audio_changeable = false
					current = selected
				elif album[current].volume_db <= -30 && !staticIsPlaying:
					staticIsPlaying = true
					radio_static.play()
					radio_static.volume_db = -80
					audio_changeable = false
				if staticIsPlaying && radio_static.volume_db < max_volume:
					radio_static.volume_db += 2
					audio_changeable = false
				elif staticIsPlaying && radio_static.volume_db > max_volume:
					radio_static.volume_db = max_volume
					audio_changeable = true
		else:
			current = selected
		rand_num = 1 #rng.randi_range(1, 3)
	change_style()
	change_loops()
	
	if !staticIsPlaying && !songIsPlaying:
		radio_static.play()
		radio_static.volume_db = max_volume
		staticIsPlaying = true
		audio_changeable = true
	elif staticIsPlaying && radio_static.volume_db <= -80:
		# Start playing desired track or commercial
		album[current].play(0)
		album[current].volume_db = max_volume
		staticIsPlaying = false
		songIsPlaying = true
		audio_changeable = true
	elif staticIsPlaying && radio_static.get_playback_position() > 2.13:
		radio_static.volume_db -= 1
		audio_changeable = false
	
	if songIsPlaying:
		if album[current].volume_db <= -60:
			songIsPlaying = false
			album[current].stop()
			audio_changeable = false
		elif album[current].get_playback_position() > album[current].stream.get_length() - 1:
			album[current].volume_db -= 1
			audio_changeable = false
	
	if (player.position.y > 750) || player.hasMacguffin2:
		# Pandemonium 2
		selected = 7
	elif player.position.x > -90 && player.position.x < 17500 && player.position.y < 130 && player.position.y > -3300:
		# Areas 1, 2, and 3
		selected = 0
	elif player.position.x > 2200 && player.position.x < 12890 && player.position.y < -3300 && player.position.y > -6350:
		# Areas 4 and 5
		selected = 1
	elif player.position.x > 6200 && player.position.x < 17990 && player.position.y < -6350 && player.position.y > -12410:
		# Areas 6 and 7
		selected = 2
	elif player.position.x > 7100 && player.position.x < 22090 && player.position.y < -12410 && player.position.y > -19260:
		# Areas 8 and 9
		selected = 3
	elif player.position.x > 10800 && player.position.x < 17400 && player.position.y < -19260 && player.position.y > -25000:
		# Areas 10 and 11
		selected = 4
	elif player.position.x > -90 && player.position.x < 26850 && player.position.y < -23000:
		# Space
		selected = 5
	elif player.position.x > 17500 && player.position.x < 26850 && player.position.y < 750 && player.position.y > -12250:
		# Pandemonium 1
		selected = 6
	
	if audio_changeable:
		if songIsPlaying:
			album[current].volume_db = max_volume
		if staticIsPlaying:
			radio_static.volume_db = max_volume
	pass
	
func change_style():
	if radio_sound != radio_sound_bool:
		radio_sound = radio_sound_bool
	pass

func change_loops():
	if current_rand != rand_num:
		if rand_num == 1:
			if radio_sound:
				song1 = get_node("LostAgainRadio")
				song2 = get_node("DontLookDownRadio")
				song3 = get_node("TestofPatienceRadio")
				song4 = get_node("TrialsAboundRadio")
				song5 = get_node("CantTurnBackRadio")
			else:
				song1 = get_node("LostAgain")
				song2 = get_node("DontLookDown")
				song3 = get_node("TestofPatience")
				song4 = get_node("TrialsAbound")
				song5 = get_node("CantTurnBack")
		elif rand_num == 2:
			if radio_sound:
				song1 = get_node("LostAgainRadio2")
				song2 = get_node("DontLookDownRadio2")
				song3 = get_node("TestofPatienceRadio2")
				song4 = get_node("TrialsAboundRadio2")
				song5 = get_node("CantTurnBackRadio2")
			else:
				song1 = get_node("LostAgain2")
				song2 = get_node("DontLookDown2")
				song3 = get_node("TestofPatience2")
				song4 = get_node("TrialsAbound2")
				song5 = get_node("CantTurnBack2")
		elif rand_num == 3:
			if radio_sound:
				song1 = get_node("LostAgainRadio3")
				song2 = get_node("DontLookDownRadio3")
				song3 = get_node("TestofPatienceRadio3")
				song4 = get_node("TrialsAboundRadio3")
				song5 = get_node("CantTurnBackRadio3")
			else:
				song1 = get_node("LostAgain3")
				song2 = get_node("DontLookDown3")
				song3 = get_node("TestofPatience3")
				song4 = get_node("TrialsAbound3")
				song5 = get_node("CantTurnBack3")
		album = [song1, song2, song3, song4, song5, song6, song7, song8]
		current_rand = rand_num
	pass

func change_volume(volume):
	var temp_volume = 0
	if volume >= 51:
		temp_volume = (0.48 * volume) - 24
	elif volume < 51:
		temp_volume = (1.6 * volume) - 80
	return temp_volume
	pass
