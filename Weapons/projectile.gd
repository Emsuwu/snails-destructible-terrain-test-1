class_name WeaponProjectile
extends RigidBody2D

@onready var sprite: Sprite2D = $Sprite

var weapon : Weapon
var bounces_made : int
var initial_power : float
var initial_direction : Vector2
var has_launched : bool
var explosions_made : int

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
	explode(weapon.explosion_radius)

func _on_body_entered(body: Node):
	print("HIT")

	if body.is_in_group("InstantDeathBarrier"):
		Snail.cycle_team()
		queue_free()
		return

	if weapon.bounces_before_explosion != -1:
		bounces_made += 1
		if bounces_made > weapon.bounces_before_explosion:
			explode(weapon.explosion_radius)

	print("Bounces before explosion:", weapon.bounces_before_explosion)
	print("Bounces:", bounces_made)

func explode(radius : int):
	var center = get_projectile_tilemap_pos()
	for cel_pos in get_cells_in_radius(center, radius):
		TerrainTilemap.instance.set_cell(cel_pos, -1)
	Effect.explode(global_position, weapon)
	explosions_made += 1

	if explosions_made >= weapon.explosion_amount:
		queue_free()

func get_projectile_tilemap_pos() -> Vector2i:
	var local_position = TerrainTilemap.instance.to_local(global_position)
	var cell_position = TerrainTilemap.instance.local_to_map(local_position)
	return cell_position
func get_cells_in_radius(center: Vector2i, radius : int) -> Array[Vector2i]:
	var cells_in_radius : Array[Vector2i]
	for cell in TerrainTilemap.instance.get_used_cells():
		var pos : Vector2i = Vector2i(cell.x, cell.y)
		if check_is_cell_in_radius(center, pos, radius):
			cells_in_radius.append(pos)
	return cells_in_radius

func check_is_cell_in_radius(center : Vector2i, cell_pos : Vector2i, radius : int) -> bool:
	return (cell_pos.x - center.x)*(cell_pos.x - center.x) + (cell_pos.y - center.y)*(cell_pos.y - center.y) < radius*radius
