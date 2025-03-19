extends Node2D

var user_prefs: UserPreferences

var dice_opposite
var dipper_opposite
var mush_setter
var mp3_setter
var oof_setter
var player

# Called when the node enters the scene tree for the first time.
func _ready():
	user_prefs = UserPreferences.load_or_create()
	dice_opposite = !user_prefs.achievement_dice
	#dipper_opposite = (user_prefs.achievement_big_dipper || user_prefs.achievement_little_dipper)
	mush_setter = user_prefs.achievement_mushroom
	oof_setter = user_prefs.achievement_oof
	mp3_setter = user_prefs.achievement_mp3
	player = get_parent()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if !user_prefs.demo && Steam.isSteamRunning():
		if user_prefs.achievement_dice:
			if dice_opposite:
				handle_dice_achievement()
		if user_prefs.achievement_big_dipper || user_prefs.achievement_little_dipper:
			handle_dipper_achievement()
		if !user_prefs.achievement_mushroom:
			handle_mushroom_achievement()
		if !user_prefs.achievement_oof:
			handle_oof_achievement()
		if !user_prefs.achievement_mp3:
			handle_mp3_achievement()
	pass

func handle_dice_achievement():
	dice_opposite = !user_prefs.achievement_dice
	if !Steam.getAchievement("ACHIEVEMENT_DICE")["achieved"]:
		Steam.setAchievement("ACHIEVEMENT_DICE")
		Steam.storeStats()
	user_prefs.save()
	pass

func handle_dipper_achievement():
	dipper_opposite = (user_prefs.achievement_big_dipper || user_prefs.achievement_little_dipper)
	if !Steam.getAchievement("ACHIEVEMENT_DIPPER")["achieved"]:
		Steam.setAchievement("ACHIEVEMENT_DIPPER")
		Steam.storeStats()
		user_prefs.save()
	pass

func handle_mushroom_achievement():
	if player.countBounces >= 5:
		mush_setter = true
	if mush_setter && player.velocity.y == 0:
		if !Steam.getAchievement("ACHIEVEMENT_MUSHROOM")["achieved"]:
			Steam.setAchievement("ACHIEVEMENT_MUSHROOM")
			Steam.storeStats()
			user_prefs.achievement_mushroom = true
			user_prefs.save()
	pass

func handle_mp3_achievement():
	for child in get_tree().root.get_node("Overworld/MP3s").get_children():
		if child.name.contains("MP3"):
			true # Finish this later

func handle_oof_achievement():
	if player.countHangTime > 1190:
		oof_setter = true
	if oof_setter && player.velocity.y == 0:
		if !Steam.getAchievement("ACHIEVEMENT_OOF")["achieved"]:
			Steam.setAchievement("ACHIEVEMENT_OOF")
			Steam.storeStats()
			user_prefs.achievement_oof = true
			user_prefs.save()
	pass
