extends Sprite2D

var initial
var in_fade = false
var number = 0
var out_fade = false

# Called when the node enters the scene tree for the first time.
func _ready():
	number = int(String(get_parent().name))
	initial = position
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	#if in_fade:
	#	fade_in()
	#elif out_fade:
	#	fade_out()
	position.y -= 5
	pass

func fade_in():
	if self_modulate.a < .65:
		self_modulate.a += .02
	elif self_modulate.a > .65:
		in_fade = false
	pass

func fade_out():
	if self_modulate.a > 0:
		self_modulate.a -= .02
	elif self_modulate.a <= 0:
		position = initial
		out_fade = false
	pass

func _on_area_2d_area_entered(area):
	if area.name.contains("WindCurrent"):
		if int(String(area.name)) == number:
			in_fade = true
	pass # Replace with function body.

func _on_area_2d_area_exited(area):
	if area.name.contains("WindCurrent"):
		if int(String(area.name)) == number:
			out_fade = true
	pass # Replace with function body.
