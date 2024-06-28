extends Area2D

var dialogue
var indexer = 0
var interacting = false
var isNearSign = false
var textCount = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	dialogue = get_meta("DIALOGUE")
	textCount = dialogue.size()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if interacting && !Input.is_action_just_pressed("ui_click"):
		if indexer == 0:
			print(isNearSign, interacting, indexer, textCount)
			%DialogueBox.visible = true
			%DialogueBox.get_node("RichTextLabel").text = dialogue[indexer]
		elif indexer == textCount - 1:
			indexer = 0
			%DialogueBox.visible = false
			interacting = false
		elif indexer < textCount - 1:
			indexer += 1
	if isNearSign && Input.is_action_just_pressed("ui_click") && indexer != textCount - 1:
		interacting = true
	pass

func _on_body_entered(body):
	if body.name == "Player":
		isNearSign = true
	pass # Replace with function body.

func _on_body_exited(body):
	if body.name == "Player":
		isNearSign = false
	pass # Replace with function body.
