extends Node2D

var user_prefs: UserPreferences

# Called when the node enters the scene tree for the first time.
func _ready():
	user_prefs = UserPreferences.load_or_create()
	#print("i am here")
	pass # Replace with function body.
