extends Node2D

var user_prefs: UserPreferences

# Called when the node enters the scene tree for the first time.
func _ready():
	user_prefs = UserPreferences.load_or_create()
	if user_prefs.difficulty_dropdown_index == 0:
		$OverworldRelaxed.process_mode = Node.PROCESS_MODE_PAUSABLE
		#$OverworldFoddian.process_mode = Node.PROCESS_MODE_DISABLED
		#$OverworldPermadeath.process_mode = Node.PROCESS_MODE_DISABLED
	elif user_prefs.difficulty_dropdown_index == 1:
		$OverworldRelaxed.process_mode = Node.PROCESS_MODE_DISABLED
		#$OverworldFoddian.process_mode = Node.PROCESS_MODE_PAUSABLE
		#$OverworldPermadeath.process_mode = Node.PROCESS_MODE_DISABLED
	elif user_prefs.difficulty_dropdown_index == 2:
		$OverworldRelaxed.process_mode = Node.PROCESS_MODE_DISABLED
		#$OverworldFoddian.process_mode = Node.PROCESS_MODE_DISABLED
		#$OverworldPermadeath.process_mode = Node.PROCESS_MODE_PAUSABLE
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
