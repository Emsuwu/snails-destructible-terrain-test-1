class_name Snail
extends CharacterBody2D

enum SnailTeam { BLUE, RED, YELLOW, GREEN }
@export var selected_weapon : Weapon
@export var _snail_name : String
@export var _team : SnailTeam
@export var _health : int = 100
@export var blue : Color
@export var red : Color
@export var yellow : Color
@export var green : Color

var health : int:
	get:
		return _health

@onready var nametag = $Name
@onready var health_label: RichTextLabel = $HealthLabel
@onready var reticle_sprite: Sprite2D = $AimPivot/AimReticle/ReticleSprite

static var focus : Snail
static var gravity_multiplier : float = 1000
static var teams : Array[Array] = [[],[],[],[]]
static var current_snail_in_teams : Array[int] = [0,0,0,0]
static var current_team : int
static var jump_height : float = 300
static var has_fired_shot_this_turn : bool
static var is_game_over : bool

var is_active : bool

func damage(amount : int):
	_health -= amount
	if _health < 0: 
		_health = 0
		on_death(true)
	health_label.text = str(_health)

func _ready():
	is_active = false
	_start()

static func start_all():
	for team in teams:
		for snail in team:
			snail._start()
func _start():
	set_snail_name(_snail_name)
	set_team(_team)
	is_active = true
	damage(randi_range(0,99))

	focus = teams[current_team][current_snail_in_teams[current_team]]

static func reset_statics():
	focus = null
	teams = [[],[],[],[]]
	current_snail_in_teams = [0,0,0,0]
	current_team = 0
	has_fired_shot_this_turn = false
	is_game_over = false

func set_snail_name(snail_name : String):
	_snail_name = snail_name
	nametag.text = _snail_name

static func cycle_snail_in_team():
	has_fired_shot_this_turn = false
	if teams[current_snail_in_teams[current_team]].size() != 0: current_snail_in_teams[current_team] = ( current_snail_in_teams[current_team] + 1 ) % teams[current_snail_in_teams[current_team]].size()
	update_focus()
static func cycle_team():
	has_fired_shot_this_turn = false
	if SnailTeam.size() != 0: current_team = (current_team + 1) % SnailTeam.size()
	Terrain.instance.randomize_wind()
	update_focus()

	print("--------")
	print("Teams: ", teams)
	print("Current team: ", current_team)
	print("Current snail in teams: ",current_snail_in_teams)
	print("Active snail: ", focus)

static func update_focus(recursion_depth : int = 0):
	if recursion_depth > teams.size():
		print("Game over")
		Snail.is_game_over = true
		Terrain.instance.game_over_label.show()
		return
	if teams[current_team].is_empty():
		current_team = (current_team + 1) % teams.size()
		update_focus(recursion_depth + 1)
	if Snail.is_game_over: return
	focus = teams[current_team][current_snail_in_teams[current_team]]

static func focus_random():
	focus = teams[0][0]
	# var starting_team : int = randi_range(0, teams.size()-1)
	# var starting_snail : int = randi_range(0, teams[starting_team].size()-1)
	# focus = teams[starting_team][starting_snail]

func on_death(is_instant : bool = false):
	print("Stu-pid!")
	if is_instant:
		call_deferred("_check_game_over")
		if Snail.focus == self: cycle_team()
		remove_from_team(self)
		self.queue_free()

func _check_game_over():
	var found_active_team : bool = false
	print(teams)
	for team in teams:
		if !team.is_empty(): found_active_team = true
	if !found_active_team: Terrain.instance.game_over_label.show()

func set_team(team : SnailTeam):
	_team = team
	if _team == SnailTeam.BLUE:
		nametag["theme_override_colors/default_color"] = blue
		health_label["theme_override_colors/default_color"] = blue
		reticle_sprite.modulate = blue
	if _team == SnailTeam.RED:
		nametag["theme_override_colors/default_color"] = red
		health_label["theme_override_colors/default_color"] = red
		reticle_sprite.modulate = red
	if _team == SnailTeam.YELLOW:
		nametag["theme_override_colors/default_color"] = yellow
		health_label["theme_override_colors/default_color"] = yellow
		reticle_sprite.modulate = yellow
	if _team == SnailTeam.GREEN:
		nametag["theme_override_colors/default_color"] = green
		health_label["theme_override_colors/default_color"] = green
		reticle_sprite.modulate = green

	remove_from_team(self)
	teams[team].append(self)

func remove_from_team(snail : Snail):
	# Remove from any existing team
	for i in range(teams.size()):
		if self in teams[i]:
			teams[i].erase(snail)
