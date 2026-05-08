class_name CameraFocusPoint
extends Node2D

@export var auto_focus : bool
@export var lerp_weight : float = .5
static var current : CameraFocusPoint

func _ready():
    if !auto_focus: return
    focus()

func focus():
    CameraFocusPoint.current = self

func detach_and_destroy_in_secs(secs: float):
    reparent(Terrain.instance)
    await get_tree().create_timer(secs).timeout
    queue_free()