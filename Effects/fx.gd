class_name FX
extends Node
@onready var explosion_effect: PackedScene = preload("uid://0h00tcth2pdj")

func explode(global_pos : Vector2, weapon : Weapon):
	var new_explosion : ExplosionEffect = explosion_effect.instantiate()
	Terrain.instance.add_child(new_explosion)
	new_explosion.global_position = global_pos
	new_explosion.play(weapon)
