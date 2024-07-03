extends Node2D

@onready var left = $UI_Sprite2D_left
@onready var right = $UI_Sprite2D_right

# Called when the node enters the scene tree for the first time.
func _ready():
	left.visible = false
	right.visible = false
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if %Player.swingRope != null:
		if %Player.swingRope.get_parent().name == name:
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
	else:
		left.play("idle")
		right.play("idle")
		left.visible = false
		right.visible = false
	pass
