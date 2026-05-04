extends Camera2D

@export var _lerp_weight : float = .2

func _process(_delta):
	if Snail.focus == null: return
	position.x = lerpf( position.x, Snail.focus.position.x, _lerp_weight)
	position.y = lerpf( position.y, Snail.focus.position.y, _lerp_weight)
