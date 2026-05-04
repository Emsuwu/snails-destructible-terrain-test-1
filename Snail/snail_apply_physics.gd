extends Node

var is_enabled = true
var snail : CharacterBody2D
var gravity : Vector2 = ProjectSettings.get_setting("physics/2d/default_gravity_vector")

func _ready():
	snail = owner

func _physics_process(delta):
	if !is_enabled: return
	snail.velocity.x *= 0.85
	snail.velocity += gravity * Snail.gravity_multiplier * delta
	snail.move_and_slide()
