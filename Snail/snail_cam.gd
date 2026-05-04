extends Camera2D

@export var _lerp_weight : float = .2

func _process(delta):
	if Snail.current == null: return
	position.x = lerpf( position.x, Snail.current.position.x, _lerp_weight)
	position.y = lerpf( position.y, Snail.current.position.y, _lerp_weight)
