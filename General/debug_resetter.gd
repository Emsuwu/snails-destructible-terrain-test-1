extends Node

func _process(_delta):
	if Input.is_action_just_pressed("debug_reset"):
		Terrain.instance._loading_label.show()
		Snail.reset_statics()
		get_tree().reload_current_scene()