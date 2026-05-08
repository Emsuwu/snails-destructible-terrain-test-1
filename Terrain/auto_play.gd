extends AnimationPlayer

@export var animation_to_play : String

func _ready():
    play(animation_to_play)