extends CanvasLayer

var user_prefs: UserPreferences

# Called when the node enters the scene tree for the first time.
func _ready():
	user_prefs = UserPreferences.load_or_create()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if %TimerDisplay.h < 10 && !user_prefs.achievement_speedrun1:
		user_prefs.achievement_speedrun1 = true
		if !Steam.getAchievement("ACHIEVEMENT_SPEEDRUN1")["achieved"]:
			Steam.setAchievement("ACHIEVEMENT_SPEEDRUN1")
	if %TimerDisplay.h < 3 && !user_prefs.achievement_speedrun2:
		user_prefs.achievement_speedrun2 = true
		if !Steam.getAchievement("ACHIEVEMENT_SPEEDRUN2")["achieved"]:
			Steam.setAchievement("ACHIEVEMENT_SPEEDRUN2")
	if (%TimerDisplay.h == 0 && %TimerDisplay.m < 15) && !user_prefs.achievement_speedrun3:
		user_prefs.achievement_speedrun3 = true
		if !Steam.getAchievement("ACHIEVEMENT_SPEEDRUN3")["achieved"]:
			Steam.setAchievement("ACHIEVEMENT_SPEEDRUN3")
	if get_parent().name == "DrivingEnding" && !user_prefs.achievement_car:
		user_prefs.achievement_car = true
		if !Steam.getAchievement("ACHIEVEMENT_CAR")["achieved"]:
			Steam.setAchievement("ACHIEVEMENT_CAR")
	elif get_parent().name == "SpaceEnding" && !user_prefs.achievement_space:
		user_prefs.achievement_space = true
		if !Steam.getAchievement("ACHIEVEMENT_SPACE")["achieved"]:
			Steam.setAchievement("ACHIEVEMENT_SPACE")
	elif get_parent().name == "SummitEnding" && !user_prefs.achievement_mountain:
		user_prefs.achievement_mountain = true
		print(user_prefs.achievement_mountain)
		if !Steam.getAchievement("ACHIEVEMENT_MOUNTAIN")["achieved"]:
			Steam.setAchievement("ACHIEVEMENT_MOUNTAIN")
	if %Macguffin.visible && !user_prefs.achievement_flag:
		user_prefs.achievement_flag = true
		if !Steam.getAchievement("ACHIEVEMENT_FLAG")["achieved"]:
			Steam.setAchievement("ACHIEVEMENT_FLAG")
	if %Macguffin3.visible && !user_prefs.achievement_medal:
		user_prefs.achievement_medal = true
		if !Steam.getAchievement("ACHIEVEMENT_MEDAL")["achieved"]:
			Steam.setAchievement("ACHIEVEMENT_MEDAL")
	handle_robot_achievement()
	
	user_prefs.save()
	pass

func handle_robot_achievement():
	if !user_prefs.achievement_robot:
		if user_prefs.relaxed_boots_flag && user_prefs.relaxed_rockets_flag &&  user_prefs.relaxed_jetpack_flag:
			user_prefs.achievement_robot = true
			if !Steam.getAchievement("ACHIEVEMENT_ROBOT")["achieved"]:
				Steam.setAchievement("ACHIEVEMENT_ROBOT")
		if user_prefs.foddian_boots_flag && user_prefs.foddian_rockets_flag &&  user_prefs.foddian_jetpack_flag:
			user_prefs.achievement_robot = true
			if !Steam.getAchievement("ACHIEVEMENT_ROBOT")["achieved"]:
				Steam.setAchievement("ACHIEVEMENT_ROBOT")
		if user_prefs.permadeath_boots_flag && user_prefs.permadeath_rockets_flag &&  user_prefs.permadeath_jetpack_flag:
			user_prefs.achievement_robot = true
			if !Steam.getAchievement("ACHIEVEMENT_ROBOT")["achieved"]:
				Steam.setAchievement("ACHIEVEMENT_ROBOT")
	pass
