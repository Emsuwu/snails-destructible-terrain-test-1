class_name Snail
extends CharacterBody2D

static var current : Snail
static var gravity_multiplier : float = 1000
static var snails : Array[Snail]
static var jump_height : float = 300

func _ready():
	if current == null: current = self
	snails.append(self)
