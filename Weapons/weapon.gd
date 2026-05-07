class_name Weapon
extends Resource

enum RotationBehaviour { 
    DIRECTIONAL, ## Uses the vector of travel to set direction
    SPIN, ## Spins based on travel direction and speed
    NONE ## Take a guess
    }

## The name of the weapon in the inventory
@export var weapon_name : String = "Unnamed weapon"
@export_group("Sprites")
## The weapon icon used in the inventory
@export var icon : Texture2D
## The projectile icon
@export var projectile_sprite : Texture2D
## The weapon sprite as shown in a snail's hand
@export var held_weapon_sprite : Texture2D
## An offset applied to the weapon when held in a snail's hand
@export var held_weapon_offset : Vector2

@export_group("Audio")
## Array of sounds that could play upon weapon use. One will be picked at random.
@export var use_sounds : Array[AudioStream]
## Array of travel sounds. One will be picked at random.
@export var travel_sounds : Array[AudioStream]
## Whether or not the travel sounds should be looped
@export var loop_travel_sounds : bool = true
## Array of sounds that could play upon projectile explosion. One will be picked at random.
@export var explosion_sounds : Array[AudioStream]

@export_group("Behaviour")
## The radius of an explosion upon impact
@export var explosion_radius : int
## Bounces before explosion. 0 if doesn't bounce. -1 for infinite.
@export_range(-1, 10) var bounces_before_explosion : int
## When the projectile is used, what is the initial velocity? This is multiplied by power. 1000 is a good starting point.
@export var initial_speed : float = 800
## Time it takes for the projectile to automatically explode. 0: no countdown.
@export_range(0, 100) var explosion_countdown : float
## How many explosions will happen before the projectile is freed
@export_range(1, 20) var explosion_amount : int = 1

@export_subgroup("Forces")
## How much the projectile is affected by wind
@export_range(0, 10) var wind_coefficient : float = 0
## How much the projectile is affected by gravity
@export_range(0, 10) var gravity_coefficient : float = 1
## Drag coefficient. This number is multiplied by velocity.x to simulate drag. 1 for no drag.
@export_range(0, 1) var horizontal_drag_coefficient : float = 0.985

@export_subgroup("Visual")
## How projectile rotation is handled
@export var rotation_behaviour : RotationBehaviour
## How quickly rotation occurs
@export_range(0.05, 1) var turn_speed : float