extends Camera2D

func _process(delta):
	if Input.is_action_pressed("up"):
		position.y -= delta * 1000
	if Input.is_action_pressed("down"):
		position.y += delta * 1000
	if Input.is_action_pressed("left"):
		position.x -= delta * 1000
	if Input.is_action_pressed("right"):
		position.x += delta * 1000
