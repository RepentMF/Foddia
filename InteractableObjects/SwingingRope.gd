extends Node2D

@onready var left = $UI_Keyboard_left
@onready var up = $UI_Keyboard_up
@onready var right = $UI_Keyboard_right
@onready var down = $UI_Keyboard_down

var currentSwingMethod
var disabled
var player

var orange = Color(.945, .494, .095)
var yellow = Color(1, .980, .267)
var blue = Color(.059, .369, .969)
var green = Color(.059, .655, .255)
var pink = Color(.937, .373, .902)

# Called when the node enters the scene tree for the first time.
func _ready():
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
			if currentSwingMethod == "Bumpers":
				up.visible = false
				down.visible = false
				left.visible = true
				right.visible = true
			else:
				up.visible = true
				down.visible = true
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
			if Input.is_action_just_pressed("ui_up"):
				up.play("pressed")
			elif Input.is_action_just_released("ui_up"):
				up.play("idle")
			if Input.is_action_just_pressed("ui_down"):
				down.play("pressed")
			elif Input.is_action_just_released("ui_down"):
				down.play("idle")
		else:
			up.visible = false
			down.visible = false
			left.visible = false
			right.visible = false
	elif left.visible && right.visible && up.visible && down.visible: #elif check if left and right are already playing idle; if they are, do nothing
		left.play("idle")
		up.play("idle")
		right.play("idle")
		down.play("idle")
		left.visible = false
		up.visible = false
		right.visible = false
		down.visible = false
	pass

func change_colors():
	# Orange
	if %UserPrefsController.user_prefs.title_color_index == 0:
		$UI_Keyboard_left.modulate = orange
		$UI_Keyboard_up.modulate = orange
		$UI_Keyboard_right.modulate = orange
		$UI_Keyboard_down.modulate = orange
		$UI_Arrow_left.modulate = orange
		$UI_Arrow_up.modulate = orange
		$UI_Arrow_right.modulate = orange
		$UI_Arrow_down.modulate = orange
		$UI_Controller_left.modulate = orange
		$UI_Controller_right.modulate = orange
	# Yellow
	elif %UserPrefsController.user_prefs.title_color_index == 2:
		$UI_Keyboard_left.modulate = yellow
		$UI_Keyboard_up.modulate = yellow
		$UI_Keyboard_right.modulate = yellow
		$UI_Keyboard_down.modulate = yellow
		$UI_Arrow_left.modulate = yellow
		$UI_Arrow_up.modulate = yellow
		$UI_Arrow_right.modulate = yellow
		$UI_Arrow_down.modulate = yellow
		$UI_Controller_left.modulate = yellow
		$UI_Controller_right.modulate = yellow
	# Blue
	elif %UserPrefsController.user_prefs.title_color_index == 3:
		$UI_Keyboard_left.modulate = blue
		$UI_Keyboard_up.modulate = blue
		$UI_Keyboard_right.modulate = blue
		$UI_Keyboard_down.modulate = blue
		$UI_Arrow_left.modulate = blue
		$UI_Arrow_up.modulate = blue
		$UI_Arrow_right.modulate = blue
		$UI_Arrow_down.modulate = blue
		$UI_Controller_left.modulate = blue
		$UI_Controller_right.modulate = blue
	# Green
	elif %UserPrefsController.user_prefs.title_color_index == 4:
		$UI_Keyboard_left.modulate = green
		$UI_Keyboard_up.modulate = green
		$UI_Keyboard_right.modulate = green
		$UI_Keyboard_down.modulate = green
		$UI_Arrow_left.modulate = green
		$UI_Arrow_up.modulate = green
		$UI_Arrow_right.modulate = green
		$UI_Arrow_down.modulate = green
		$UI_Controller_left.modulate = green
		$UI_Controller_right.modulate = green
	# Pink
	elif %UserPrefsController.user_prefs.title_color_index == 5:
		$UI_Keyboard_left.modulate = pink
		$UI_Keyboard_up.modulate = pink
		$UI_Keyboard_right.modulate = pink
		$UI_Keyboard_down.modulate = pink
		$UI_Arrow_left.modulate = pink
		$UI_Arrow_up.modulate = pink
		$UI_Arrow_right.modulate = pink
		$UI_Arrow_down.modulate = pink
		$UI_Controller_left.modulate = pink
		$UI_Controller_right.modulate = pink
	pass

func change_icons():
	if player.currentSwingMethod == "Keyboard":
		left = $UI_Keyboard_left
		up = $UI_Keyboard_up
		right = $UI_Keyboard_right
		down = $UI_Keyboard_down
		$UI_Arrow_left.visible = false
		$UI_Arrow_up.visible = false
		$UI_Arrow_right.visible = false
		$UI_Arrow_down.visible = false
		$UI_Arrow_left.play("idle")
		$UI_Arrow_up.play("idle")
		$UI_Arrow_right.play("idle")
		$UI_Arrow_down.play("idle")
		$UI_Controller_left.visible = false
		$UI_Controller_right.visible = false
		$UI_Controller_left.play("idle")
		$UI_Controller_right.play("idle")
	elif player.currentSwingMethod == "DPAD":
		left = $UI_Arrow_left
		up = $UI_Arrow_up
		right = $UI_Arrow_right
		down = $UI_Arrow_down
		$UI_Keyboard_left.visible = false
		$UI_Keyboard_up.visible = false
		$UI_Keyboard_right.visible = false
		$UI_Keyboard_down.visible = false
		$UI_Keyboard_left.play("idle")
		$UI_Keyboard_up.play("idle")
		$UI_Keyboard_right.play("idle")
		$UI_Keyboard_down.play("idle")
		$UI_Controller_left.visible = false
		$UI_Controller_right.visible = false
		$UI_Controller_left.play("idle")
		$UI_Controller_right.play("idle")
	elif player.currentSwingMethod == "Bumpers":
		left = $UI_Controller_left
		right = $UI_Controller_right
		up.visible = false
		down.visible = false
		$UI_Arrow_left.visible = false
		$UI_Arrow_up.visible = false
		$UI_Arrow_right.visible = false
		$UI_Arrow_down.visible = false
		$UI_Arrow_left.play("idle")
		$UI_Arrow_up.play("idle")
		$UI_Arrow_right.play("idle")
		$UI_Arrow_down.play("idle")
		$UI_Keyboard_left.visible = false
		$UI_Keyboard_up.visible = false
		$UI_Keyboard_right.visible = false
		$UI_Keyboard_down.visible = false
		$UI_Keyboard_left.play("idle")
		$UI_Keyboard_up.play("idle")
		$UI_Keyboard_right.play("idle")
		$UI_Keyboard_down.play("idle")
		$UI_Controller_left.visible = false
		$UI_Controller_right.visible = false
		$UI_Controller_left.play("idle")
		$UI_Controller_right.play("idle")
	currentSwingMethod = player.currentSwingMethod
	pass
