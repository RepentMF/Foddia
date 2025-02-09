extends Node2D

var count = 300
var willFall = false
var temp_volume

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if temp_volume != get_tree().root.get_node("Overworld").get_node("SFXVolumeHandler").SFX_volume:
		temp_volume = get_tree().root.get_node("Overworld").get_node("SFXVolumeHandler").SFX_volume + 10
		get_parent().get_node("RopeSnap").volume_db = temp_volume
	if willFall:
		if count == 300:
			get_parent().get_node("RopeSnap").play()
			print(get_parent().get_node("RopeSnap").is_playing())
		if count > 0:
			count -= 1
		elif count == 0:
			for i in get_parent().get_children():
				if i.name.contains("RopeLinkage"):
					i.gravity_scale = 0.3
			get_parent().get_node("RopeLinkageTop").freeze = false
			get_parent().get_node("RopeLinkageTop").hasFallen = true
			for i in get_parent().get_children():
				if i.name.contains("RopeLinkage"):
					i.name = "NoUse"
			queue_free()
	pass
