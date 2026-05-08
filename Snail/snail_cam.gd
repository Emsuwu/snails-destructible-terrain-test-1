extends Camera2D

@export var _lerp_weight : float

func _process(_delta):
	if CameraFocusPoint.current != null: focus_point()
	elif Snail.focus != null: focus_snail()

func focus_point():
	global_position.x = lerpf( global_position.x, CameraFocusPoint.current.global_position.x, CameraFocusPoint.current.lerp_weight)
	global_position.y = lerpf( global_position.y, CameraFocusPoint.current.global_position.y, CameraFocusPoint.current.lerp_weight)

func focus_snail():
	global_position.x = lerpf( global_position.x, Snail.focus.global_position.x, _lerp_weight)
	global_position.y = lerpf( global_position.y, Snail.focus.global_position.y, _lerp_weight)