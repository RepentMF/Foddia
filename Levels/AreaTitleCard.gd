extends RichTextLabel

var fadeInCount
var fadeInMax
var fadeOutCount
var fadeOutMax
var waitCount
var waitMax
var startCount
var shown

var current
var player
var previous
var selected
var title1
var title2
var title3
var title4
var title5
var title6
var title7
var title8
var title9
var title10
var title11
var title12
var title13
var title_card_text
var titles

# Called when the node enters the scene tree for the first time.
func _ready():
	fadeInCount = 0
	fadeInMax = 280
	fadeOutCount = 0
	fadeOutMax = 280
	waitCount = 0
	waitMax = 300
	shown = true
	previous = -1
	selected = -2
	current = -3
	startCount = 0
	#choose_area()
	player = %Player
	title_card_text = ""
	title1 = "                   The Foddian Forest"
	title2 = "                          Beta Bluffs"
	title3 = "           Construction Yard Cliffs"
	title4 = "                Mushroom Matching"
	title5 = "                          Flash Falls"
	title6 = "             Pumped Puffball Project"
	title7 = "                     Dyno Dangling"
	title8 = "                    Switching Swings"
	title9 = "                      Sliding Smear"
	title10 = "                         The Problem"
	title11 = "                 Mount Foddy Summit"
	title12 = "           Space - the Final Frontier"
	title13 = "Pandemonium - Madness Incarnate"
	titles = [title1, title2, title3, title4, title5, title6, title7, title8, title9, title10, title11, title12, title13]
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	choose_area()
	#text = title_card_text
	pass

func choose_area():
	if player.position.x > 500 && player.position.x < 5820 && player.position.y < 130 && player.position.y > -3300:
		# Area 1
		selected = 0
	elif player.position.x > 5820 && player.position.x < 14600 && player.position.y < 130 && player.position.y > -3300:
		# Area 2
		selected = 1
	elif player.position.x > 14600 && player.position.x < 17750 && player.position.y < 130 && player.position.y > -3300:
		# Area 3
		selected = 2
	elif player.position.x > 6450 && player.position.x < 12800 && player.position.y < -3300 && player.position.y > -6350:
		# Area 4
		selected = 3
	elif player.position.x > -90 && player.position.x < 6450 && player.position.y < -3300 && player.position.y > -6350:
		# Area 5
		selected = 4
	elif player.position.x > 6430 && player.position.x < 10800 && player.position.y < -6350 && player.position.y > -7440:
		# Area 6
		selected = 5
	elif player.position.x > 6555 && player.position.x < 16270 && player.position.y < -7440 && player.position.y > -12435:
		# Area 7
		selected = 6
	elif player.position.x > 7100 && player.position.x < 22090 && player.position.y < -12435 && player.position.y > -17380:
		# Area 8
		selected = 7
	elif player.position.x > 9730 && player.position.x < 14275 && player.position.y < -17380 && player.position.y > -19260:
		# Area 9
		selected = 8
	elif player.position.x > 14340 && player.position.x < 17850 && player.position.y < -19260 && player.position.y > -22530:
		# Area 10
		selected = 9
	elif player.position.x > 15760 && player.position.x < 16525 && player.position.y < -22530 && player.position.y > -22850:
		# Area 11
		selected = 10
	elif player.position.x > -90 && player.position.x < 26850 && player.position.y < -23000:
		# Space
		selected = 11
	elif player.position.x > 18000 && player.position.x < 26850 && player.position.y < 750 && player.position.y > -1600:
		# Pandemonium 1
		selected = 12
	
	if selected != current && shown:
		if previous == selected:
			startCount += 1
		if previous != selected && selected != -2:
			previous = selected
			startCount = 0
		elif startCount > 124 && previous == selected:
			startCount = 0
			current = selected
			text = titles[selected]
			shown = false
	elif selected == current && !shown:
		if fadeInCount < fadeInMax:
			fadeInCount += 1
			if fadeInCount % 20 == 0:
				modulate.a += .0745
				if modulate.a > 1:
					modulate.a = 1
		elif waitCount < waitMax:
			waitCount += 1
		elif fadeOutCount < fadeOutMax:
			fadeOutCount += 1
			if fadeOutCount % 20 == 0:
				modulate.a -= .0745
				if modulate.a < 0:
					modulate.a = 0
					startCount = 0
					fadeInCount = 0
					fadeOutCount = 0
					waitCount = 0
					shown = true
	pass
