extends Node2D

var album
var audio_changeable
var current
var current_rand
var current_song
var current_string
var commercialIsPlaying
var foreverAlbum: Array[Node] = []
var foreverRadioAlbum: Array[Node] = []
var itemIsPlaying
var itemWasPlaying
var master_album: Array[Node] = []
var max_volume
var mp3Selected = -1
var mp3Song = false
var player
var previous
var radio_sound
var radio_static
var rand_num
var rng
var selected
var selected_song
var song1
var song2
var song3
var song4
var song5
var song6
var song7
var song8
var song9
var songHasStarted
var staticIsPlaying
var style_changed

func _ready():
	audio_changeable = false
	current = -1
	current_rand = -1
	if %UserPrefsController.user_prefs.difficulty_dropdown_index == 0:
		current_string = %UserPrefsController.user_prefs.rel_last_song
	elif %UserPrefsController.user_prefs.difficulty_dropdown_index == 1:
		current_string = %UserPrefsController.user_prefs.fod_last_song
	elif %UserPrefsController.user_prefs.difficulty_dropdown_index == 2:
		current_string = %UserPrefsController.user_prefs.per_last_song
	if current_string == "":
		current_string = "LostAgain"
	itemIsPlaying = false
	itemWasPlaying = false
	player = get_parent()
	radio_static = get_node("RadioStatic")
	rng = RandomNumberGenerator.new()
	rng.randomize()
	rand_num = rng.randi_range(1, 3)
	selected_song = ""
	songHasStarted = false
	staticIsPlaying = true
	style_changed = false
	store_all_songs()
	change_style()
	change_loops()
	pass

func _physics_process(_delta):
	#if radio_static && songHasStarted:
	#	print_values()
	if max_volume != %OSTVolumeHandler.OST_volume:
		max_volume = %OSTVolumeHandler.OST_volume
	# Handle Song Change in Background
	change_style()
	change_loops()
	if current_song != current_string && !mp3Song:
		current_song = current_string
		album[current].stop()
		if current != -1:
			previous = current
		for n in album.size():
			if album[n].get_meta("name").contains(current_song):
				current = n
		staticIsPlaying = true
		radio_static.play()
		songHasStarted = false
	elif mp3Song && mp3Selected != %PauseMenu.get_node("MarginContainer/AudioOptions/Node2D/ChangeSong").selected:
		choose_mp3()
	
	# Gameplan
	# -Static plays
	# Then an RNG or a list of variables choose whether or not a commerical or song should play
	# Then commercial or song plays
	# -Loop back to static playing, repeat process
	# If new song appears during commercial, save song into variable and leave it until needed use
	# If new song appears during current song, save song into variable and play static- then new song
	# -If an item jingle needs to play, stop everything, play the jingle, then go back to static
	
	# If an item jingle needs to play, stop everything, play the jingle, then go back to static
	if itemIsPlaying:
		stop_other_songs()
		album[current].stop()
		itemWasPlaying = true
		songHasStarted = false
		commercialIsPlaying = false
	elif itemWasPlaying:
		itemWasPlaying = false
		staticIsPlaying = true
		radio_static.play()
	else:
		# Song plays
		if songHasStarted && !commercialIsPlaying && !staticIsPlaying && !mp3Song:
			if !album[current].is_playing():
				album[current].play()
				foreverRadioAlbum[mp3Selected - 1].stop()
				foreverAlbum[mp3Selected - 1].stop()
				songHasStarted = false
		elif mp3Song && mp3Selected != -1:
			album[current].stop()
			if radio_sound:
				if !foreverRadioAlbum[mp3Selected - 1].is_playing():
					foreverRadioAlbum[mp3Selected - 1].play()
			else:
				if !foreverAlbum[mp3Selected - 1].is_playing():
					foreverAlbum[mp3Selected - 1].play()
		
		if current != -1:
			if album[current].volume_db != max_volume:
				album[current].volume_db = max_volume
			if foreverAlbum[mp3Selected - 1].volume_db != max_volume:
				foreverAlbum[mp3Selected - 1].volume_db = max_volume
			if foreverRadioAlbum[mp3Selected - 1].volume_db != max_volume:
				foreverRadioAlbum[mp3Selected - 1].volume_db = max_volume
		if staticIsPlaying:
			radio_static.volume_db = max_volume
		#print_values()
	pass
	
func change_style():
	if radio_sound != %UserPrefsController.user_prefs.radio_songs_bool_check:
		radio_sound = %UserPrefsController.user_prefs.radio_songs_bool_check
		style_changed = true
	pass

func change_loops():
	if current_rand != rand_num || style_changed:
		if current != -1:
			if (album[current].to_string().contains("Radio") && !radio_sound) || (!album[current].to_string().contains("Radio") && radio_sound):
				songHasStarted = false
				commercialIsPlaying = false
			album[current].stop()
			radio_static.play()
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
		song6 = get_node("SummitAir")
		song7 = get_node("MaytheStarsFollowYou")
		album = [song1, song2, song3, song4, song5, song6, song7, song8, song9]
		current_rand = rand_num
		style_changed = false
		if current != -1:
			for n in album.size():
				if album[n].get_meta("name").contains(current_song):
					current = n
	pass

func choose_mp3():
	var i = 0
	for AudioStreamPlayer2D in foreverAlbum:
		foreverAlbum[i].stop()
		foreverRadioAlbum[i].stop()
		i += 1
	mp3Selected = %PauseMenu.get_node("MarginContainer/AudioOptions/Node2D/ChangeSong").selected

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
	master_album.push_front(get_node("SummitAir"))
	
	foreverAlbum.push_front(get_node("GnawingDesiresForever"))
	foreverAlbum.push_front(get_node("MaytheStarsFollowYouForever"))
	foreverAlbum.push_front(get_node("PainfulLongingForever"))
	foreverAlbum.push_front(get_node("CantTurnBackForever"))
	foreverAlbum.push_front(get_node("TrialsAboundForever"))
	foreverAlbum.push_front(get_node("TestofPatienceForever"))
	foreverAlbum.push_front(get_node("DontLookDownForever"))
	foreverAlbum.push_front(get_node("LostAgainForever"))
	
	foreverRadioAlbum.push_front(get_node("GnawingDesiresForever"))
	foreverRadioAlbum.push_front(get_node("MaytheStarsFollowYouForever"))
	foreverRadioAlbum.push_front(get_node("PainfulLongingForever"))
	foreverRadioAlbum.push_front(get_node("CantTurnBackRadioForever"))
	foreverRadioAlbum.push_front(get_node("TrialsAboundRadioForever"))
	foreverRadioAlbum.push_front(get_node("TestofPatienceRadioForever"))
	foreverRadioAlbum.push_front(get_node("DontLookDownRadioForever"))
	foreverRadioAlbum.push_front(get_node("LostAgainRadioForever"))
	pass

func stop_other_songs():
	for n in master_album.size():
		if !master_album[n].name.contains(current_song):
			master_album[n].stop()
	radio_static.stop()
	pass

func print_values():
	print(" ")
	print("Audio is changeable: ", audio_changeable)
	print("Current song number: ", current)
	print("What is current song supposed to be?")
	print(current_song)
	if current != -1:
		print("Name: ", album[current].get_meta("name"))
	print("Is radio filter turned on?")
	if current != -1:
		if album[current].to_string().contains("Radio"):
			print("Yes")
		else:
			print("No")
	print("Should radio filter be turned on?")
	if radio_sound:
		print("Yes")
	else:
		print("No")
	print("Current Random Loops: ", current_rand)
	print("Commercial is playing: ", commercialIsPlaying)
	print("Item jingle is playing: ", itemIsPlaying)
	print("Song has started: ", songHasStarted)
	print("Radio static is playing: ", staticIsPlaying)

func _on_radio_static_finished():
	if !player.game_start:
		if !mp3Song:
			songHasStarted = true
		staticIsPlaying = false
		# func roll for song or commercial
	pass # Replace with function body.

func _on_song_finished():
	staticIsPlaying = true
	# Static plays when commercial is finished or when a song is finished
	radio_static.play()
	pass
