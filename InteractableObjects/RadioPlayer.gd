extends Node2D

var user_prefs: UserPreferences

var album
var audio_changeable
var current
var current_rand
var commercialIsPlaying
var itemIsPlaying
var master_album: Array[Node] = []
var max_volume
var player
var radio_sound
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
var song9
var songIsPlaying
var staticIsPlaying

func _ready():
	user_prefs = UserPreferences.load_or_create()
	audio_changeable = false
	current_rand = -1
	itemIsPlaying = false
	player = get_parent()
	radio_static = get_node("RadioStatic")
	rng = RandomNumberGenerator.new()
	rng.randomize()
	rand_num = rng.randi_range(1, 3)
	songIsPlaying = false
	staticIsPlaying = false
	store_all_songs()
	change_style()
	change_loops()
	pass

func _physics_process(delta):
	#print_values()
	if max_volume != %OSTVolumeHandler.OST_volume:
		max_volume = %OSTVolumeHandler.OST_volume
	
	if itemIsPlaying:
		album[current].stop()
		songIsPlaying = false
		commercialIsPlaying = false
		staticIsPlaying = false
	else:
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
						rand_num = rng.randi_range(1, 3)
					if staticIsPlaying && radio_static.volume_db < max_volume:
						radio_static.volume_db += 2
						audio_changeable = false
					elif staticIsPlaying && radio_static.volume_db > max_volume:
						radio_static.volume_db = max_volume
						audio_changeable = true
			else:
				current = selected
		
		if !staticIsPlaying && !songIsPlaying:
			radio_static.play()
			radio_static.volume_db = max_volume
			staticIsPlaying = true
			audio_changeable = true
		elif staticIsPlaying && radio_static.volume_db <= -80:
			# Start playing desired track or commercial
			if current != null:
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
				radio_static.volume_db = max_volume
			elif album[current].get_playback_position() > album[current].stream.get_length() - 1 || current != selected:
				album[current].volume_db -= 1
				audio_changeable = false
		
		if (player.position.y > 750) || player.hasMacguffin2:
			# Pandemonium 2
			selected = 8
		elif player.position.x > -90 && player.position.x < 17500 && player.position.y < 130 && player.position.y > -3300:
			# Areas 1, 2, and 3
			selected = 0
		elif player.position.x > 2200 && player.position.x < 12890 && player.position.y < -3300 && player.position.y > -6350:
			# Areas 4 and 5
			selected = 1
		elif player.position.x > 6200 && player.position.x < 17990 && player.position.y < -6350 && player.position.y > -12410:
			# Areas 6 and 7
			selected = 2
		elif player.position.x > 7100 && player.position.x < 22090 && player.position.y < -12410 && player.position.y > -17300:
			# Area 8
			selected = 3
		elif player.position.x > 10800 && player.position.x < 17400 && player.position.y < -17300 && player.position.y > -22530:
			# Areas 9 and 10
			selected = 4
		elif player.position.x > 15760 && player.position.x < 16525 && player.position.y < -22530 && player.position.y > -22850:
			# Area 11
			selected = 5
		elif player.position.x > -90 && player.position.x < 26850 && player.position.y < -23000:
			# Space, change song to radio static later on
			selected = 6
			if current == 6:
				album[current].stop()
		elif player.position.x > 17500 && player.position.x < 26850 && player.position.y < 750 && player.position.y > -12250:
			# Pandemonium 1
			selected = 7
		
		if audio_changeable:
			if songIsPlaying:
				album[current].volume_db = max_volume
			if staticIsPlaying:
				radio_static.volume_db = max_volume
		
		change_style()
		change_loops()
	pass
	
func change_style():
	if radio_sound != user_prefs.radio_songs_bool_check:
		radio_sound = user_prefs.radio_songs_bool_check
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
				song8 = get_node("PainfulLonging")
				song9 = get_node("GnawingDesires")
			else:
				song1 = get_node("LostAgain")
				song2 = get_node("DontLookDown")
				song3 = get_node("TestofPatience")
				song4 = get_node("TrialsAbound")
				song5 = get_node("CantTurnBack")
				song8 = get_node("PainfulLonging")
				song9 = get_node("GnawingDesires")
		elif rand_num == 2:
			if radio_sound:
				song1 = get_node("LostAgainRadio2")
				song2 = get_node("DontLookDownRadio2")
				song3 = get_node("TestofPatienceRadio2")
				song4 = get_node("TrialsAboundRadio2")
				song5 = get_node("CantTurnBackRadio2")
				song8 = get_node("PainfulLonging2")
				song9 = get_node("GnawingDesires2")
			else:
				song1 = get_node("LostAgain2")
				song2 = get_node("DontLookDown2")
				song3 = get_node("TestofPatience2")
				song4 = get_node("TrialsAbound2")
				song5 = get_node("CantTurnBack2")
				song8 = get_node("PainfulLonging2")
				song9 = get_node("GnawingDesires2")
		elif rand_num == 3:
			if radio_sound:
				song1 = get_node("LostAgainRadio3")
				song2 = get_node("DontLookDownRadio3")
				song3 = get_node("TestofPatienceRadio3")
				song4 = get_node("TrialsAboundRadio3")
				song5 = get_node("CantTurnBackRadio3")
				song8 = get_node("PainfulLonging3")
				song9 = get_node("GnawingDesires3")
			else:
				song1 = get_node("LostAgain3")
				song2 = get_node("DontLookDown3")
				song3 = get_node("TestofPatience3")
				song4 = get_node("TrialsAbound3")
				song5 = get_node("CantTurnBack3")
				song8 = get_node("PainfulLonging3")
				song9 = get_node("GnawingDesires3")
		album = [song1, song2, song3, song4, song5, song6, song7, song8, song9]
		current_rand = rand_num
		if current != null:
			stop_other_songs()
	pass

func store_all_songs():
	master_album.push_front(get_node("LostAgainRadio"))
	master_album.push_front(get_node("DontLookDownRadio"))
	master_album.push_front(get_node("TestofPatienceRadio"))
	master_album.push_front(get_node("TrialsAboundRadio"))
	master_album.push_front(get_node("CantTurnBackRadio"))
	master_album.push_front(get_node("LostAgainRadio2"))
	master_album.push_front(get_node("DontLookDownRadio2"))
	master_album.push_front(get_node("TestofPatienceRadio2"))
	master_album.push_front(get_node("TrialsAboundRadio2"))
	master_album.push_front(get_node("CantTurnBackRadio2"))
	master_album.push_front(get_node("LostAgainRadio3"))
	master_album.push_front(get_node("DontLookDownRadio3"))
	master_album.push_front(get_node("TestofPatienceRadio3"))
	master_album.push_front(get_node("TrialsAboundRadio3"))
	master_album.push_front(get_node("CantTurnBackRadio3"))
	master_album.push_front(get_node("LostAgain"))
	master_album.push_front(get_node("DontLookDown"))
	master_album.push_front(get_node("TestofPatience"))
	master_album.push_front(get_node("TrialsAbound"))
	master_album.push_front(get_node("CantTurnBack"))
	master_album.push_front(get_node("LostAgain2"))
	master_album.push_front(get_node("DontLookDown2"))
	master_album.push_front(get_node("TestofPatience2"))
	master_album.push_front(get_node("TrialsAbound2"))
	master_album.push_front(get_node("CantTurnBack2"))
	master_album.push_front(get_node("LostAgain3"))
	master_album.push_front(get_node("DontLookDown3"))
	master_album.push_front(get_node("TestofPatience3"))
	master_album.push_front(get_node("TrialsAbound3"))
	master_album.push_front(get_node("CantTurnBack3"))
	master_album.push_front(get_node("PainfulLonging"))
	master_album.push_front(get_node("GnawingDesires"))
	master_album.push_front(get_node("PainfulLonging2"))
	master_album.push_front(get_node("GnawingDesires2"))
	master_album.push_front(get_node("PainfulLonging3"))
	master_album.push_front(get_node("GnawingDesires3"))
	pass

func stop_other_songs():
	for n in master_album.size():
		if master_album[n].name != album[current].name:
			master_album[n].stop()
	pass

func print_values():
	#print(" ")
	#print("Audio is changeable: ", audio_changeable)
	#print("Current: ", current)
	#print("Current Random Loops: ", current_rand)
	#print("Commercial is playing: ", commercialIsPlaying)
	#print("Item jingle is playing: ", itemIsPlaying)
	#print("Song is playing: ", songIsPlaying)
	print("Radio static is playing: ", staticIsPlaying)
