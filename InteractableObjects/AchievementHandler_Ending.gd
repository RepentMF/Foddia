extends CanvasLayer

var user_prefs: UserPreferences

# Called when the node enters the scene tree for the first time.
func _ready():
	user_prefs = UserPreferences.load_or_create()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if !user_prefs.demo && Steam.isSteamRunning():
		if %TimerDisplay.h < 10 && !user_prefs.achievement_speedrun1:
			user_prefs.achievement_speedrun1 = true
			if !Steam.getAchievement("ACHIEVEMENT_SPEEDRUN1")["achieved"]:
				Steam.setAchievement("ACHIEVEMENT_SPEEDRUN1")
				Steam.storeStats()
				user_prefs.save()
		if %TimerDisplay.h < 3 && !user_prefs.achievement_speedrun2:
			user_prefs.achievement_speedrun2 = true
			if !Steam.getAchievement("ACHIEVEMENT_SPEEDRUN2")["achieved"]:
				Steam.setAchievement("ACHIEVEMENT_SPEEDRUN2")
				Steam.storeStats()
				user_prefs.save()
		if (%TimerDisplay.h == 0 && %TimerDisplay.m < 15) && !user_prefs.achievement_speedrun3:
			user_prefs.achievement_speedrun3 = true
			if !Steam.getAchievement("ACHIEVEMENT_SPEEDRUN3")["achieved"]:
				Steam.setAchievement("ACHIEVEMENT_SPEEDRUN3")
				Steam.storeStats()
				user_prefs.save()
		if get_parent().name == "DrivingEnding" && !user_prefs.achievement_car:
			user_prefs.achievement_car = true
			if !Steam.getAchievement("ACHIEVEMENT_CAR")["achieved"]:
				Steam.setAchievement("ACHIEVEMENT_CAR")
				Steam.storeStats()
				user_prefs.save()
		elif get_parent().name == "SpaceEnding" && !user_prefs.achievement_space:
			user_prefs.achievement_space = true
			if !Steam.getAchievement("ACHIEVEMENT_SPACE")["achieved"]:
				Steam.setAchievement("ACHIEVEMENT_SPACE")
				Steam.storeStats()
				user_prefs.save()
		elif get_parent().name == "SummitEnding" && !user_prefs.achievement_mountain:
			user_prefs.achievement_mountain = true
			if !Steam.getAchievement("ACHIEVEMENT_MOUNTAIN")["achieved"]:
				Steam.setAchievement("ACHIEVEMENT_MOUNTAIN")
				Steam.storeStats()
				user_prefs.save()
		if %Macguffin.visible && !user_prefs.achievement_flag:
			user_prefs.achievement_flag = true
			if !Steam.getAchievement("ACHIEVEMENT_FLAG")["achieved"]:
				Steam.setAchievement("ACHIEVEMENT_FLAG")
				Steam.storeStats()
				user_prefs.save()
		if %Macguffin3.visible && !user_prefs.achievement_medal:
			user_prefs.achievement_medal = true
			if !Steam.getAchievement("ACHIEVEMENT_MEDAL")["achieved"]:
				Steam.setAchievement("ACHIEVEMENT_MEDAL")
				Steam.storeStats()
				user_prefs.save()
		handle_robot_achievement()
	pass

func handle_robot_achievement():
	if !user_prefs.achievement_robot:
		if user_prefs.relaxed_boots_flag && user_prefs.relaxed_rockets_flag &&  user_prefs.relaxed_jetpack_flag:
			user_prefs.achievement_robot = true
			if !Steam.getAchievement("ACHIEVEMENT_ROBOT")["achieved"]:
				Steam.setAchievement("ACHIEVEMENT_ROBOT")
				Steam.storeStats()
				user_prefs.save()
		if user_prefs.foddian_boots_flag && user_prefs.foddian_rockets_flag &&  user_prefs.foddian_jetpack_flag:
			user_prefs.achievement_robot = true
			if !Steam.getAchievement("ACHIEVEMENT_ROBOT")["achieved"]:
				Steam.setAchievement("ACHIEVEMENT_ROBOT")
				Steam.storeStats()
				user_prefs.save()
		if user_prefs.permadeath_boots_flag && user_prefs.permadeath_rockets_flag &&  user_prefs.permadeath_jetpack_flag:
			user_prefs.achievement_robot = true
			if !Steam.getAchievement("ACHIEVEMENT_ROBOT")["achieved"]:
				Steam.setAchievement("ACHIEVEMENT_ROBOT")
				Steam.storeStats()
				user_prefs.save()
	pass
