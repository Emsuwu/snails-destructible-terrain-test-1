extends Node

@export var _sprite : Sprite2D
@export var _animator : AnimationPlayer
@onready var aim_pivot: Node2D = $'../AimPivot'
@onready var reticle_sprite: Sprite2D = $'../AimPivot/AimReticle/ReticleSprite'
@onready var aim_animator : AnimationPlayer = $'../AimPivot/AimReticle/AimBar/AimAnimator'
@onready var aim_bar : Line2D = $'../AimPivot/AimReticle/AimBar'
@onready var weapon_sprite : Sprite2D = $'../AimPivot/AimReticle/WeaponSprite'
@onready var projectile: PackedScene = preload("res://Weapons/projectile.tscn")
@export var aim_audio_stream_player : AudioStreamPlayer2D

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
	if !snail.is_active: return
	if Snail.focus != snail: 
		_animator.stop()
		reticle_sprite.hide()
		weapon_sprite.hide()
	if !is_enabled: return
	if Snail.focus != snail: return
	_do_movement(delta)
	_do_aiming(delta)
	_do_firing()

func _do_aiming(delta : float):
	reticle_sprite.show()
	if snail.selected_weapon != null:
		_set_weapon_visuals()
	else:
		weapon_sprite.hide()

	if Input.is_action_pressed("aim_up"):
		aim_rotation_offset += delta * RETICLE_ROTATE_SPEED
	if Input.is_action_pressed("aim_down"):
		aim_rotation_offset -= delta * RETICLE_ROTATE_SPEED

	aim_rotation_offset = clampf(aim_rotation_offset, -90, 90)

	if is_facing_right:
		aim_pivot.rotation_degrees = 180 - aim_rotation_offset
	else:
		aim_pivot.rotation_degrees = 0 + aim_rotation_offset

func _set_weapon_visuals():
	weapon_sprite.texture = snail.selected_weapon.held_weapon_sprite
	weapon_sprite.offset = -snail.selected_weapon.held_weapon_offset
	weapon_sprite.show()

func _do_firing():
	if snail.selected_weapon == null: return
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
	aim_animator.stop()
	aim_bar.hide()
	Snail.has_fired_shot_this_turn = true
	var new_projectile : WeaponProjectile = projectile.instantiate()
	var direction : Vector2 = Vector2.RIGHT.rotated(deg_to_rad(aim_pivot.rotation_degrees - 180))
	Terrain.instance.add_child(new_projectile)
	new_projectile.launch(snail.selected_weapon, power, direction, snail.global_position)
	aim_audio_stream_player.stop()

func _do_movement(delta : float):
	_is_moving = false
	if Snail.has_fired_shot_this_turn: return
	if (Input.is_action_pressed("left")):
		_is_moving = true
		snail.velocity.x = -100
		_sprite.flip_h = false
		weapon_sprite.flip_v = false
		if _wall_left: 
			snail.velocity.y -= 500 * delta
	if (Input.is_action_pressed("right")):
		_is_moving = true
		_sprite.flip_h = true
		snail.velocity.x = 100
		weapon_sprite.flip_v = true
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
