extends Node2D

var album
var current
var commercialIsPlaying
var player
var rng
var selected
var song1
var song2
var songIsPlaying
var staticIsPlaying

func _ready():
	player = get_parent()
	rng = RandomNumberGenerator.new()
	rng.randomize()
	song1 = get_node("CantTurnBack")
	song2 = get_node("LostAgain")
	
	album = [song1, song2]
	pass

func _physics_process(delta):
	if current != selected:
		current = selected
		for i in album.size():
			if i == current:
				if !album[i].is_playing():
					album[i].play()
			else:
				album[i].stop()
	
	if (player.position.x < 21400 && player.position.y > 1000) || player.hasMacguffin2:
		# Pandemonium 2
		selected = 11
	elif player.position.x > -90 && player.position.x < 5700 && player.position.y < 130 && player.position.y > -2200:
		# Area 1
		selected = 0
	elif player.position.x > 5700 && player.position.x < 14500 && player.position.y < 130 && player.position.y > -2200:
		# Area 2
		selected = 1
	elif player.position.x > 14500 && player.position.x < 17500 && player.position.y < 130 && player.position.y > -3500:
		# Area 3
		selected = 2
	elif player.position.x > 6500 && player.position.x < 14500 && player.position.y < -2200 && player.position.y > -7250:
		# Area 4 or Area 6
		selected = 3
	elif player.position.x > -90 && player.position.x < 6500 && player.position.y < -2200 && player.position.y > -6400:
		# Area 5
		selected = 4
	elif player.position.x > -90 && player.position.x < 17500 && player.position.y < -7250 && player.position.y > -12250:
		# Area 7
		selected = 5
	elif player.position.x > -90 && player.position.x < 26850 && player.position.y < -12250 && player.position.y > -17250:
		# Area 8
		selected = 6
	elif player.position.x > 9600 && player.position.x < 13900 && player.position.y < -17250 && player.position.y > -19000:
		# Area 9
		selected = 7
	elif player.position.x > 10500 && player.position.x < 18100 && player.position.y < -19000 && player.position.y > -23000:
		# Area 10
		selected = 8
	elif player.position.x > -90 && player.position.x < 26850 && player.position.y < -23000:
		# Space
		selected = 9
	elif player.position.x > 17500 && player.position.x < 26850 && player.position.y < -1000 && player.position.y > -12250:
		# Pandemonium 1
		selected = 10
	pass
