extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if !%UserPrefsController.user_prefs.demo && Steam.isSteamRunning():
		if %TimerDisplay.h < 10 && !%UserPrefsController.user_prefs.achievement_speedrun1:
			%UserPrefsController.user_prefs.achievement_speedrun1 = true
			if !Steam.getAchievement("ACHIEVEMENT_SPEEDRUN1")["achieved"]:
				Steam.setAchievement("ACHIEVEMENT_SPEEDRUN1")
				Steam.storeStats()
				%UserPrefsController.user_prefs.save()
		if %TimerDisplay.h < 3 && !%UserPrefsController.user_prefs.achievement_speedrun2:
			%UserPrefsController.user_prefs.achievement_speedrun2 = true
			if !Steam.getAchievement("ACHIEVEMENT_SPEEDRUN2")["achieved"]:
				Steam.setAchievement("ACHIEVEMENT_SPEEDRUN2")
				Steam.storeStats()
				%UserPrefsController.user_prefs.save()
		if (%TimerDisplay.h == 0 && %TimerDisplay.m < 15) && !%UserPrefsController.user_prefs.achievement_speedrun3:
			%UserPrefsController.user_prefs.achievement_speedrun3 = true
			if !Steam.getAchievement("ACHIEVEMENT_SPEEDRUN3")["achieved"]:
				Steam.setAchievement("ACHIEVEMENT_SPEEDRUN3")
				Steam.storeStats()
				%UserPrefsController.user_prefs.save()
		if get_parent().name == "DrivingEnding" && !%UserPrefsController.user_prefs.achievement_car:
			%UserPrefsController.user_prefs.achievement_car = true
			if !Steam.getAchievement("ACHIEVEMENT_CAR")["achieved"]:
				Steam.setAchievement("ACHIEVEMENT_CAR")
				Steam.storeStats()
				%UserPrefsController.user_prefs.save()
		elif get_parent().name == "SpaceEnding" && !%UserPrefsController.user_prefs.achievement_space:
			%UserPrefsController.user_prefs.achievement_space = true
			if !Steam.getAchievement("ACHIEVEMENT_SPACE")["achieved"]:
				Steam.setAchievement("ACHIEVEMENT_SPACE")
				Steam.storeStats()
				%UserPrefsController.user_prefs.save()
		elif get_parent().name == "SummitEnding" && !%UserPrefsController.user_prefs.achievement_mountain:
			%UserPrefsController.user_prefs.achievement_mountain = true
			if !Steam.getAchievement("ACHIEVEMENT_MOUNTAIN")["achieved"]:
				Steam.setAchievement("ACHIEVEMENT_MOUNTAIN")
				Steam.storeStats()
				%UserPrefsController.user_prefs.save()
		if %Macguffin.visible && !%UserPrefsController.user_prefs.achievement_flag:
			%UserPrefsController.user_prefs.achievement_flag = true
			if !Steam.getAchievement("ACHIEVEMENT_FLAG")["achieved"]:
				Steam.setAchievement("ACHIEVEMENT_FLAG")
				Steam.storeStats()
				%UserPrefsController.user_prefs.save()
		if %Macguffin3.visible && !%UserPrefsController.user_prefs.achievement_medal:
			%UserPrefsController.user_prefs.achievement_medal = true
			if !Steam.getAchievement("ACHIEVEMENT_MEDAL")["achieved"]:
				Steam.setAchievement("ACHIEVEMENT_MEDAL")
				Steam.storeStats()
				%UserPrefsController.user_prefs.save()
		handle_robot_achievement()
	pass

func handle_robot_achievement():
	if !%UserPrefsController.user_prefs.achievement_robot:
		if %UserPrefsController.user_prefs.relaxed_boots_flag && %UserPrefsController.user_prefs.relaxed_rockets_flag &&  %UserPrefsController.user_prefs.relaxed_jetpack_flag:
			%UserPrefsController.user_prefs.achievement_robot = true
			if !Steam.getAchievement("ACHIEVEMENT_ROBOT")["achieved"]:
				Steam.setAchievement("ACHIEVEMENT_ROBOT")
				Steam.storeStats()
				%UserPrefsController.user_prefs.save()
		if %UserPrefsController.user_prefs.foddian_boots_flag && %UserPrefsController.user_prefs.foddian_rockets_flag &&  %UserPrefsController.user_prefs.foddian_jetpack_flag:
			%UserPrefsController.user_prefs.achievement_robot = true
			if !Steam.getAchievement("ACHIEVEMENT_ROBOT")["achieved"]:
				Steam.setAchievement("ACHIEVEMENT_ROBOT")
				Steam.storeStats()
				%UserPrefsController.user_prefs.save()
		if %UserPrefsController.user_prefs.permadeath_boots_flag && %UserPrefsController.user_prefs.permadeath_rockets_flag &&  %UserPrefsController.user_prefs.permadeath_jetpack_flag:
			%UserPrefsController.user_prefs.achievement_robot = true
			if !Steam.getAchievement("ACHIEVEMENT_ROBOT")["achieved"]:
				Steam.setAchievement("ACHIEVEMENT_ROBOT")
				Steam.storeStats()
				%UserPrefsController.user_prefs.save()
	pass
