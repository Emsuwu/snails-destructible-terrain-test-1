class_name WeaponProjectile
extends RigidBody2D

@onready var sprite: Sprite2D = $Sprite

var weapon : Weapon
var bounces_made : int
var initial_power : float
var initial_direction : Vector2
var has_launched : bool

func _physics_process(delta):
	if !has_launched: return
	_do_visual_rotation(delta)

func _do_visual_rotation(delta : float):

	var travel_dir : float = -1 if linear_velocity.x < 0 else 1

	if weapon.rotation_behaviour == weapon.RotationBehaviour.SPIN:
		sprite.rotation_degrees += ( weapon.turn_speed * delta * linear_velocity.length() * travel_dir )
	elif weapon.rotation_behaviour == weapon.RotationBehaviour.DIRECTIONAL:
		sprite.rotation_degrees = rad_to_deg( linear_velocity.angle() )

func launch(used_weapon : Weapon, use_power : float, use_direction : Vector2, global_spawn_position : Vector2):
	initial_power = use_power
	initial_direction = use_direction.normalized()
	weapon = used_weapon
	global_position = global_spawn_position
	sprite.texture = weapon.projectile_sprite
	has_launched = true

	gravity_scale = weapon.gravity_coefficient

	var launch_velocity = initial_direction * initial_power * weapon.initial_speed
	apply_central_impulse(launch_velocity)

	print("---- Firing shot -----")
	print("Fire power: ", use_power)
	print("Start vel: ", initial_power * initial_direction * weapon.initial_speed)
	print("Vel: ", linear_velocity)
	
	if weapon.explosion_countdown != 0:
		_countdown()

func _countdown():
	await get_tree().create_timer(weapon.explosion_countdown).timeout
	explode()

func _on_body_entered(body: Node):

	if body.is_in_group("InstantDeathBarrier"):
		Snail.cycle_team()
		queue_free()

	if !weapon.bounces_before_explosion == -1:
		bounces_made += 1
		if bounces_made == weapon.bounces_before_explosion + 1:
			explode()

func explode():
	print("BOOM")
	queue_free()
