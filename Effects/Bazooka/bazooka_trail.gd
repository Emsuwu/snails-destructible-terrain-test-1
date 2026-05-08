class_name ParticleTrail extends Node2D

@export var particles : Array[GPUParticles2D]
var target_node : Node2D
var is_started : bool

func start(target: Node2D):
    target_node = target
    is_started = true
    global_position = target_node.global_position
    _start_emitting()
    
func _start_emitting():
    for particle_effect in particles:
        particle_effect.emitting = true
func _process(_delta):
    if !is_started: return
    if target_node != null: 
        global_position = target_node.global_position
    else:
        for particle_effect in particles:
            particle_effect.emitting = false