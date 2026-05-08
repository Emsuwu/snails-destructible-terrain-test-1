class_name Snail
extends CharacterBody2D

enum SnailTeam { BLUE, RED, YELLOW, GREEN }
enum Emote { STOP, SIP }
var emote_anim_names : Dictionary[Emote, String] = {Emote.SIP : "sip"}
@export var _snail_name : String
@export var _team : SnailTeam
@export var _health : int = 100

@export var selected_weapon : Weapon
@export var emote_sprite : AnimatedSprite2D
@export var sprite : Sprite2D

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

func emote(animation : Emote = Emote.STOP, duration : float = -1):
	if animation == Emote.STOP:
		emote_sprite.stop()
		emote_sprite.hide()
		sprite.show()
	else:
		sprite.hide()
		emote_sprite.show()
		emote_sprite.play(emote_anim_names[animation])
	if duration > 0:
		await get_tree().create_timer(duration).timeout
		sprite.show()
		emote_sprite.stop()
		emote_sprite.hide()

func set_snail_name(snail_name : String):
	_snail_name = snail_name
	nametag.text = _snail_name

func cycle_in_secs(secs: float):
	await get_tree().create_timer(secs).timeout
	cycle()

static func cycle():
	purge_empty_teams()
	if teams.size() == 0: return
	print(teams)
	Terrain.instance.randomize_wind()
	cycle_snail_in_team()
	cycle_team()
	update_focus()
	has_fired_shot_this_turn = false

static func purge_empty_teams():
	for i in range(teams.size()-1, -1, -1):
		if teams[i].size() == 0:
			teams.remove_at(i)
	if teams.size() != 0: current_team = current_team % teams.size()

static func cycle_snail_in_team():
	current_snail_in_teams[current_team] = (current_snail_in_teams[current_team] + 1) % teams[current_team].size()

static func cycle_team():
	current_team = (current_team + 1) % teams.size()

static func update_focus():
	print("~~~")
	print(current_team)
	print(current_snail_in_teams[current_team]) # causes out of bounds error

	if current_snail_in_teams[current_team] >= teams[current_team].size():
		current_snail_in_teams[current_team] = 0

	Snail.focus = teams[current_team][current_snail_in_teams[current_team]]


static func focus_random():
	focus = teams[0][0]
	# var starting_team : int = randi_range(0, teams.size()-1)
	# var starting_snail : int = randi_range(0, teams[starting_team].size()-1)
	# focus = teams[starting_team][starting_snail]

func on_death(is_instant : bool = false):
	print("Stu-pid!")
	if is_instant:
		call_deferred("_check_game_over")
		if Snail.focus == self:
			cycle()
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
