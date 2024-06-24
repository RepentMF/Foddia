extends RichTextLabel

var ms = 0
var s = 0
var m = 0
var h = 0

var sec = ""
var min = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if ms > 9:
		s += 1
		ms = 0
	if s > 59:
		m += 1
		s = 0
	if m > 59:
		h += 1
		m = 0
	
	if s < 10:
		sec = str("0", s)
	else:
		sec = str(s)
	if m < 10:
		min = str("0", m)
	else:
		min = str(m)
	set_text(str(h) + ":" + min + ":" + sec + "." + str(ms))
	pass

func _on_timer_timeout():
	ms += 1
	pass # Replace with function body.
