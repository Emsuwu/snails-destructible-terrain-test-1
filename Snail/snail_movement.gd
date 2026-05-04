extends Node

@export var _sprite : Sprite2D
@export var _animator : AnimationPlayer

var is_enabled = true
var snail : CharacterBody2D
var gravity : Vector2 = ProjectSettings.get_setting("physics/2d/default_gravity_vector")

var _wall_left : bool = false
var _wall_right : bool = false

var _is_moving : bool = false

func _ready():
	snail = owner

func _process(delta):
	if !is_enabled: return
	if Snail.current != snail: return
	
	_is_moving = false
	if (Input.is_action_pressed("left")):
		_is_moving = true
		snail.velocity.x = -100
		_sprite.flip_h = false
		if _wall_left: 
			snail.velocity.y -= 500 * delta
	if (Input.is_action_pressed("right")):
		_is_moving = true
		_sprite.flip_h = true
		snail.velocity.x = 100
		if _wall_right: 
			snail.velocity.y -= 500 * delta
	snail.velocity.x *= 0.85
	
	if _is_moving:
		_animator.play("wiggle")
	else:
		_animator.stop()
	
	if (Input.is_action_just_pressed("up")) and (snail.is_on_floor() or (_wall_left or _wall_right)):
		snail.velocity.y = -Snail.jump_height


func _on_left_wall_detector_body_entered(_body):
	_wall_left = true
func _on_left_wall_detector_body_exited(_body):
	_wall_left = false
func _on_right_wall_detector_body_entered(_body):
	_wall_right = true
func _on_right_wall_detector_body_exited(_body):
	_wall_right = false
