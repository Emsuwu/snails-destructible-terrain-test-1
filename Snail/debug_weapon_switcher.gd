extends Node

@export var weapons : Array[Weapon]
var selected_weapon : int

func _process(_delta):
	if Snail.focus == null: return
	if Input.is_action_just_pressed("debug_next_weapon"):
		selected_weapon = ( selected_weapon + 1 ) % weapons.size()
		print("Selected:", weapons[selected_weapon].weapon_name)
		Snail.focus.selected_weapon = weapons[selected_weapon]
	if Input.is_action_just_pressed("debug_previous_weapon"):
		selected_weapon = ( selected_weapon + 1 ) % weapons.size()
		Snail.focus.selected_weapon = weapons[selected_weapon]
		print("Selected:", weapons[selected_weapon].weapon_name)
