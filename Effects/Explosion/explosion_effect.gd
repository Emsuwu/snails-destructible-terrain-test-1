class_name ExplosionEffect extends Node2D

static var effect : PackedScene = preload("res://Effects/Explosion/explosion_effect.tscn")
@export var particles : GPUParticles2D
@export var audio_stream_player : AudioStreamPlayer
var particles_finished : bool
var sound_finished : bool

## Plays the explosion effect
func play(weapon : Weapon):
	var sound : AudioStream = weapon.explosion_sounds[ randi_range(0, weapon.explosion_sounds.size()-1) ]
	particles.emitting = true
	if sound != null:
		audio_stream_player.stream = sound
		audio_stream_player.play()
func _on_gpu_particles_2d_finished():
	particles_finished = true
	#if sound_finished: 
	_destroy()
func _on_audio_stream_player_finished():
	sound_finished = true
	if particles_finished:
		_destroy()
func _destroy():
	queue_free()
