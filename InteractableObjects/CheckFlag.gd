extends Node2D

@onready var anim = $AnimatedSprite2D

var isOpened = false
var isWaving = false
var openCount = 30

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if isWaving:
		anim.play("flag_waving")
	elif !isOpened:
		anim.play("flag_idle")
	elif isOpened:
		if !anim.animation == "flag_open":
			anim.play("flag_open")
		openCount -= 1
		if openCount <= 0:
			isWaving = true
	pass

func _on_body_entered(body):
	if body.name == "Player":
		body.checkpoint = global_position
		isOpened = true
	pass # Replace with function body.
