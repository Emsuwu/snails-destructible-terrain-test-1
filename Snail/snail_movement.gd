extends Node

@export var _sprite : Sprite2D
@export var _animator : AnimationPlayer
@onready var aim_pivot: Node2D = $'../AimPivot'
@onready var reticle_sprite: Sprite2D = $'../AimPivot/AimReticle/ReticleSprite'
@onready var aim_animator: AnimationPlayer = $'../AimPivot/AimReticle/AimBar/AimAnimator'
@onready var aim_bar: Line2D = $'../AimPivot/AimReticle/AimBar'
var is_enabled = true
var aim_rotation_offset : float
var snail : CharacterBody2D
var gravity : Vector2 = ProjectSettings.get_setting("physics/2d/default_gravity_vector")
const RETICLE_ROTATE_SPEED : float = 100

var _wall_left : bool = false
var _wall_right : bool = false

var is_facing_right : bool:
	get:
		return _sprite.flip_h

var _is_moving : bool = false

func _ready():
	snail = owner
	aim_bar.hide()

func _process(delta):
	if Snail.focus != snail: 
		_animator.stop()
		reticle_sprite.hide()
	if !is_enabled: return
	if Snail.focus != snail: return
	_do_movement(delta)
	_do_aiming(delta)
	_do_firing()

func _do_aiming(delta : float):
	reticle_sprite.show()
	if Input.is_action_pressed("aim_up"):
		aim_rotation_offset += delta * RETICLE_ROTATE_SPEED
	if Input.is_action_pressed("aim_down"):
		aim_rotation_offset -= delta * RETICLE_ROTATE_SPEED

	aim_rotation_offset = clampf(aim_rotation_offset, -90, 90)

	if is_facing_right:
		aim_pivot.rotation_degrees = 180 - aim_rotation_offset
	else:
		aim_pivot.rotation_degrees = 0 + aim_rotation_offset

func _do_firing():
	if Input.is_action_pressed("fire"):
		if !aim_animator.is_playing() and !Snail.has_fired_shot_this_turn:
			aim_bar.show()
			aim_animator.play("aim_progress")
	if Input.is_action_just_released("fire"):
		if !aim_animator.is_playing(): return
		var progress : float
		progress = aim_animator.current_animation_position / aim_animator.current_animation_length
		_fire(progress)

func _fire(power : float): # normalized between 0.0 and 1.0
	if power == 0: power = 1
	print("Firing shot with power: ", power)
	aim_animator.stop()
	aim_bar.hide()
	Snail.has_fired_shot_this_turn = true

func _do_movement(delta : float):
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
