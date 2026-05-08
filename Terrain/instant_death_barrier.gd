extends Area2D

func _on_body_entered(body: Node2D):
	if body is Snail:
		body.on_death(true)
	elif body is WeaponProjectile:
		body.explode()
