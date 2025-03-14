extends Node2D

@onready var left = $UI_Keyboard_left
@onready var right = $UI_Keyboard_right
var user_prefs: UserPreferences

var currentSwingMethod
var disabled
var player

# Called when the node enters the scene tree for the first time.
func _ready():
	user_prefs = UserPreferences.load_or_create()
	left.visible = false
	right.visible = false
	disabled = false
	player = %Player
	
	change_colors()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if player.swingRope != null:
		if player.swingRope.get_parent() == self:
			if currentSwingMethod != player.currentSwingMethod:
				change_icons()
			left.visible = true
			right.visible = true
			if Input.is_action_just_pressed("ui_left"):
				left.play("pressed")
			elif Input.is_action_just_released("ui_left"):
				left.play("idle")
			if Input.is_action_just_pressed("ui_right"):
				right.play("pressed")
			elif Input.is_action_just_released("ui_right"):
				right.play("idle")
			if !disabled:
				for Node2D in get_children():
					if Node2D.name.contains("Pinjoint"):
						Node2D.disable_collision = true
				disabled = true
	elif left.visible && right.visible: #elif check if left and right are already playing idle; if they are, do nothing
		left.play("idle")
		right.play("idle")
		left.visible = false
		right.visible = false
		for Node2D in get_children():
			if Node2D.name.contains("Pinjoint"):
				Node2D.disable_collision = true
		disabled = false
	pass

func change_colors():
	if user_prefs.title_color_index == 0:
		$UI_Keyboard_left.modulate = Color(.945, .494, .095)
		$UI_Keyboard_right.modulate = Color(.945, .494, .095)
		$UI_Arrow_left.modulate = Color(.945, .494, .095)
		$UI_Arrow_right.modulate = Color(.945, .494, .095)
		$UI_Controller_left.modulate = Color(.945, .494, .095)
		$UI_Controller_right.modulate = Color(.945, .494, .095)
	elif user_prefs.title_color_index == 2:
		$UI_Keyboard_left.modulate = Color(1, .980, .267)
		$UI_Keyboard_right.modulate = Color(1, .980, .267)
		$UI_Arrow_left.modulate = Color(1, .980, .267)
		$UI_Arrow_right.modulate = Color(1, .980, .267)
		$UI_Controller_left.modulate = Color(1, .980, .267)
		$UI_Controller_right.modulate = Color(1, .980, .267)
	elif user_prefs.title_color_index == 3:
		$UI_Keyboard_left.modulate = Color(.059, .369, .969)
		$UI_Keyboard_right.modulate = Color(.059, .369, .969)
		$UI_Arrow_left.modulate = Color(.059, .369, .969)
		$UI_Arrow_right.modulate = Color(.059, .369, .969)
		$UI_Controller_left.modulate = Color(.059, .369, .969)
		$UI_Controller_right.modulate = Color(.059, .369, .969)
	elif user_prefs.title_color_index == 4:
		$UI_Keyboard_left.modulate = Color(.059, .655, .255)
		$UI_Keyboard_right.modulate = Color(.059, .655, .255)
		$UI_Arrow_left.modulate = Color(.059, .655, .255)
		$UI_Arrow_right.modulate = Color(.059, .655, .255)
		$UI_Controller_left.modulate = Color(.059, .655, .255)
		$UI_Controller_right.modulate = Color(.059, .655, .255)
	elif user_prefs.title_color_index == 5:
		$UI_Keyboard_left.modulate = Color(.937, .373, .902)
		$UI_Keyboard_right.modulate = Color(.937, .373, .902)
		$UI_Arrow_left.modulate = Color(.937, .373, .902)
		$UI_Arrow_right.modulate = Color(.937, .373, .902)
		$UI_Controller_left.modulate = Color(.937, .373, .902)
		$UI_Controller_right.modulate = Color(.937, .373, .902)
	pass

func change_icons():
	if player.currentSwingMethod == "Keyboard":
		left = $UI_Keyboard_left
		right = $UI_Keyboard_right
		$UI_Arrow_left.visible = false
		$UI_Arrow_right.visible = false
		$UI_Arrow_left.play("idle")
		$UI_Arrow_right.play("idle")
		$UI_Controller_left.visible = false
		$UI_Controller_right.visible = false
		$UI_Controller_left.play("idle")
		$UI_Controller_right.play("idle")
	elif player.currentSwingMethod == "DPAD":
		left = $UI_Arrow_left
		right = $UI_Arrow_right
		$UI_Keyboard_left.visible = false
		$UI_Keyboard_right.visible = false
		$UI_Keyboard_left.play("idle")
		$UI_Keyboard_right.play("idle")
		$UI_Controller_left.visible = false
		$UI_Controller_right.visible = false
		$UI_Controller_left.play("idle")
		$UI_Controller_right.play("idle")
	elif player.currentSwingMethod == "Bumpers":
		left = $UI_Controller_left
		right = $UI_Controller_right
		$UI_Arrow_left.visible = false
		$UI_Arrow_right.visible = false
		$UI_Arrow_left.play("idle")
		$UI_Arrow_right.play("idle")
		$UI_Controller_left.visible = false
		$UI_Controller_right.visible = false
		$UI_Controller_left.play("idle")
		$UI_Controller_right.play("idle")
	currentSwingMethod = player.currentSwingMethod
	pass
