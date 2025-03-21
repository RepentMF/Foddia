extends Node2D

@onready var anim = $AnimatedSprite2D

var openFlag
var passFlag

var isOpened = false
var isWaving = false
var openCount = 30

# Called when the node enters the scene tree for the first time.
func _ready():
	openFlag = get_node("OpenFlag")
	passFlag = get_node("PassFlag")
	if %UserPrefsController.user_prefs.difficulty_dropdown_index == 0:
		load_relaxed_flag()
	elif %UserPrefsController.user_prefs.difficulty_dropdown_index == 1:
		load_foddian_flag()
	if %UserPrefsController.user_prefs.new_game:
		isOpened = false
	pass # Replace with function body.

func _process(_delta):
	var temp_volume = %SFXVolumeHandler.SFX_volume + 15
	openFlag.volume_db = temp_volume
	passFlag.volume_db = temp_volume
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if isWaving:
		anim.play("flag_waving")
	elif !isOpened:
		anim.play("flag_idle")
	elif isOpened:
		if !anim.animation == "flag_open":
			anim.play("flag_open")
			#if !gameStart && gameCount == -1:
			#	openFlag.play()
		openCount -= 1
		if openCount <= 0 && !isWaving:
			isWaving = true
			open_map_flag()
	pass

func save_relaxed_flag():
	if name.contains("01"):
		%UserPrefsController.user_prefs.relaxed_flag1 = true
	if name.contains("02"):
		%UserPrefsController.user_prefs.relaxed_flag2 = true
	if name.contains("03"):
		%UserPrefsController.user_prefs.relaxed_flag3 = true
	if name.contains("04"):
		%UserPrefsController.user_prefs.relaxed_flag4 = true
	if name.contains("05"):
		%UserPrefsController.user_prefs.relaxed_flag5 = true
	if name.contains("06"):
		%UserPrefsController.user_prefs.relaxed_flag6 = true
	if name.contains("07"):
		%UserPrefsController.user_prefs.relaxed_flag7 = true
	if name.contains("08"):
		%UserPrefsController.user_prefs.relaxed_flag8 = true
	if name.contains("09"):
		%UserPrefsController.user_prefs.relaxed_flag9 = true
	if name.contains("10"):
		%UserPrefsController.user_prefs.relaxed_flag10 = true
	if name.contains("11"):
		%UserPrefsController.user_prefs.relaxed_flag11 = true
	if name.contains("12"):
		%UserPrefsController.user_prefs.relaxed_flag12 = true
	if name.contains("13"):
		%UserPrefsController.user_prefs.relaxed_flag13 = true
	if name.contains("14"):
		%UserPrefsController.user_prefs.relaxed_flag14 = true
	%UserPrefsController.user_prefs.save()
	pass

func load_relaxed_flag():
	if name.contains("01"):
		if %UserPrefsController.user_prefs.relaxed_flag1:
			isOpened = true
	if name.contains("02"):
		if %UserPrefsController.user_prefs.relaxed_flag2:
			isOpened = true
	if name.contains("03"):
		if %UserPrefsController.user_prefs.relaxed_flag3:
			isOpened = true
	if name.contains("04"):
		if %UserPrefsController.user_prefs.relaxed_flag4:
			isOpened = true
	if name.contains("05"):
		if %UserPrefsController.user_prefs.relaxed_flag5:
			isOpened = true
	if name.contains("06"):
		if %UserPrefsController.user_prefs.relaxed_flag6:
			isOpened = true
	if name.contains("07"):
		if %UserPrefsController.user_prefs.relaxed_flag7:
			isOpened = true
	if name.contains("08"):
		if %UserPrefsController.user_prefs.relaxed_flag8:
			isOpened = true
	if name.contains("09"):
		if %UserPrefsController.user_prefs.relaxed_flag9:
			isOpened = true
	if name.contains("10"):
		if %UserPrefsController.user_prefs.relaxed_flag10:
			isOpened = true
	if name.contains("11"):
		if %UserPrefsController.user_prefs.relaxed_flag11:
			isOpened = true
	if name.contains("12"):
		if %UserPrefsController.user_prefs.relaxed_flag12:
			isOpened = true
	if name.contains("13"):
		if %UserPrefsController.user_prefs.relaxed_flag13:
			isOpened = true
	if name.contains("14"):
		if %UserPrefsController.user_prefs.relaxed_flag14:
			isOpened = true
	pass

func save_foddian_flag():
	if name.contains("01"):
		%UserPrefsController.user_prefs.foddian_flag1 = true
	if name.contains("11"):
		%UserPrefsController.user_prefs.foddian_flag11 = true
	%UserPrefsController.user_prefs.save()
	pass

func load_foddian_flag():
	if name.contains("01"):
		if %UserPrefsController.user_prefs.foddian_flag1:
			isOpened = true
	if name.contains("11"):
		if %UserPrefsController.user_prefs.foddian_flag11:
			isOpened = true
	pass

func _on_body_entered(body):
	if body.name == "Player":
		body.checkpoint = global_position
		if isOpened:
			passFlag.play()
		else:
			isOpened = true
			openFlag.play()
		if %UserPrefsController.user_prefs.difficulty_dropdown_index == 0:
			%UserPrefsController.user_prefs.relaxed_checkname = name
			save_relaxed_flag()
		elif %UserPrefsController.user_prefs.difficulty_dropdown_index == 1:
			save_foddian_flag()
	pass # Replace with function body.

func open_map_flag():
	if isOpened:
		for child in %InteractiveMap.get_children():
			if child.name == name && !child.visible:
				child.visible = true
	pass
