extends Node2D

var user_prefs: UserPreferences
var AppID = "3351110"

# Called when the node enters the scene tree for the first time.
func _ready():
	user_prefs = UserPreferences.load_or_create()
	if !user_prefs.demo:
		OS.set_environment("SteamAppID", AppID)
		OS.set_environment("SteamGameID", AppID)
		Steam.steamInit()
		var isRunning = Steam.isSteamRunning()
		
		if isRunning:
			var id = Steam.getSteamID()
			var name = Steam.getFriendPersonaName(id)
	pass # Replace with function body.
