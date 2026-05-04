extends Node

var index : int

func _process(_delta):
	if Input.is_action_just_pressed("debug_cycle_snail"):
		Snail.cycle_snail_in_team()
	if Input.is_action_just_pressed("debug_cycle_team"):
		Snail.cycle_snail_in_team()
		Snail.cycle_team()
		print("hi")
