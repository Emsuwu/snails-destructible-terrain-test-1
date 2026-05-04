extends Node

var index : int

func _process(delta):
	if Input.is_action_just_pressed("debug_cycle_snail"):
		index = (index + 1) % Snail.snails.size()
		Snail.current = Snail.snails[index]
		print("Current snail ID: " + str(index))
