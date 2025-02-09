class_name UserPreferences extends Resource

@export var demo: bool = true

@export var new_game: bool = false
@export_range(0, 2, 1) var difficulty_dropdown_index: int = 1
@export_range(0, 1, 0.05) var music_audio_level: float = .6
@export_range(0, 1, 0.05) var sfx_audio_level: float = .6
@export var voice_acting_bool_check: bool = false
@export var radio_songs_bool_check: bool = false
@export var fullscreen_bool_check: bool = false
@export var screenshake_bool_check: bool = true
@export var crt_bool_check: bool = true
@export var title_color_index: int = 0
@export var speedrun_bool_check: bool = false
@export var tooltips_bool_check: bool = true

@export var bad_ending: bool = false
@export var achievement_big_dipper: bool = false
@export var achievement_car: bool = false
@export var achievement_flag: bool = false
@export var achievement_dice: bool = false
@export var achievement_little_dipper: bool = false
@export var achievement_medal: bool = false
@export var achievement_mountain: bool = false
@export var achievement_mushroom: bool = false
@export var achievement_oof: bool = false
@export var achievement_robot: bool = false
@export var achievement_space: bool = false
@export var achievement_speedrun1: bool = false
@export var achievement_speedrun2: bool = false
@export var achievement_speedrun3: bool = false
@export var achievement_true: bool = false

@export var relaxed_boots_flag: bool = false
@export var relaxed_rockets_flag: bool = false
@export var relaxed_jetpack_flag: bool = false
@export var relaxed_macguffin_flag: bool = false
@export var relaxed_macguffin2_flag: bool = false
@export var relaxed_macguffin3_flag: bool = false
@export var relaxed_flag1: bool = false
@export var relaxed_flag2: bool = false
@export var relaxed_flag3: bool = false
@export var relaxed_flag4: bool = false
@export var relaxed_flag5: bool = false
@export var relaxed_flag6: bool = false
@export var relaxed_flag7: bool = false
@export var relaxed_flag8: bool = false
@export var relaxed_flag9: bool = false
@export var relaxed_flag10: bool = false
@export var relaxed_flag11: bool = false
@export var relaxed_flag12: bool = false
@export var relaxed_flag13: bool = false
@export var relaxed_flag14: bool = false
@export var relaxed_ms: int = 0
@export var relaxed_s: int = 0
@export var relaxed_m: int = 0
@export var relaxed_h: int = 0
@export var relaxed_fuel_count: int = 1000
@export var relaxed_checkpoint: Vector2 = Vector2(260, 130)
@export var relaxed_save: Vector2 = Vector2(260, 130)

@export var foddian_boots_flag: bool = false
@export var foddian_rockets_flag: bool = false
@export var foddian_jetpack_flag: bool = false
@export var foddian_macguffin_flag: bool = false
@export var foddian_macguffin2_flag: bool = false
@export var foddian_macguffin3_flag: bool = false
@export var foddian_flag1: bool = false
@export var foddian_flag11: bool = false
@export var foddian_fuel_count: int = 1000
@export var foddian_ms: int = 0
@export var foddian_s: int = 0
@export var foddian_m: int = 0
@export var foddian_h: int = 0
@export var foddian_checkpoint: Vector2 = Vector2(260, 130)
@export var foddian_save: Vector2 = Vector2(260, 130)

@export var permadeath_boots_flag: bool = false
@export var permadeath_rockets_flag: bool = false
@export var permadeath_jetpack_flag: bool = false
@export var permadeath_macguffin_flag: bool = false
@export var permadeath_macguffin2_flag: bool = false
@export var permadeath_macguffin3_flag: bool = false
@export var permadeath_fuel_count: int = 1000
@export var permadeath_ms: int = 0
@export var permadeath_s: int = 0
@export var permadeath_m: int = 0
@export var permadeath_h: int = 0
@export var permadeath_save: Vector2 = Vector2(260, 130)

func save() -> void:
	ResourceSaver.save(self, "user://user_prefs.tres")
	
static func load_or_create() -> UserPreferences:
	var res: UserPreferences = load("user://user_prefs.tres") as UserPreferences
	if !res:
		res = UserPreferences.new()
	return res
