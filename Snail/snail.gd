class_name Snail
extends CharacterBody2D

enum SnailTeam { BLUE, RED, YELLOW, GREEN }
@export var snail_name : String
@export var _team : SnailTeam
@export var blue : Color
@export var red : Color
@export var yellow : Color
@export var green : Color

@onready var rich_text_label = $RichTextLabel


static var current : Snail
static var gravity_multiplier : float = 1000
static var snails : Array[Snail]
static var jump_height : float = 300

func _ready():
	if current == null: current = self
	snails.append(self)
	set_team(_team)

func set_team(set_team : SnailTeam):
	_team = set_team
	if _team == SnailTeam.BLUE:
		rich_text_label["theme_override_colors/default_color"] = blue
	if _team == SnailTeam.RED:
		rich_text_label["theme_override_colors/default_color"] = red
	if _team == SnailTeam.YELLOW:
		rich_text_label["theme_override_colors/default_color"] = yellow
	if _team == SnailTeam.GREEN:
		rich_text_label["theme_override_colors/default_color"] = green
