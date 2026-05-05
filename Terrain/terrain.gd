@tool
class_name Terrain
extends Node2D

static var instance : Terrain 

@export_tool_button("Generate Map", "Reload") var generate_map_button : Callable = func(): _generate_map()
@export var noise_type : FastNoiseLite.NoiseType = FastNoiseLite.TYPE_SIMPLEX
@export var _max_terrain_height : int = 255
@export_range(100,3000) var _terrain_length : int = 1280
@export_range(1, 4) var _terrain_stretch : int = 1
@export var _do_not_clear : bool
@export_tool_button("Update", "ArrowUp") var update_button : Callable = func(): _update_terrain()
@export_tool_button("Randomize", "Reload") var regenerate_button : Callable = func(): _generate_terrain()
@export_tool_button("Clear", "Reload") var clear_button : Callable = func(): _clear_terrain()

@export var tile_map : TileMapLayer
@export var _loading_label : RichTextLabel
@export var _wind_label : RichTextLabel
@export var game_over_label : RichTextLabel

@export var _noise_sprite : Sprite2D

@export_range(-4, 4) var _wind : int = 0

var _noise_texture : NoiseTexture2D = NoiseTexture2D.new()
var _noise_image : Image
var _noise_image_data : PackedByteArray
var _map_heights : Array[float]
var _noise : FastNoiseLite

func _ready():
	Terrain.instance = self
	if Engine.is_editor_hint(): return
	_generate_map()

func randomize_wind():
	set_wind(randi_range(-4, 4))
func set_wind(value : int):
	_wind = value
	var arrows : String = "|"
	if _wind < 0:
		arrows = ""
		for i in range(-_wind):
			arrows = arrows + "<"
		arrows = arrows + "|"
	elif _wind > 0:
		arrows = "|"
		for i in range(_wind):
			arrows = arrows + ">"
	if abs(_wind) <= 2:
		_wind_label.text = "Wind\n"+arrows
	else:
		_wind_label.text = "[wave]Wind\n"+arrows+"[/wave]"

	print("Wind:", _wind)


func _generate_map():
	_loading_label.show()
	_do_not_clear = true
	_clear_terrain()
	_generate_terrain()
	_generate_terrain()
	_generate_terrain()
	_generate_terrain()
	_do_not_clear = false
	_noise_sprite.texture = _noise_texture
	_loading_label.hide()

func _clear_terrain():
	tile_map.clear()	
func _generate_terrain():
	_generate_noise()
	_read_noise()
	tile_map.generate(_map_heights, _max_terrain_height, _terrain_stretch, _do_not_clear)
func _update_terrain():
	_read_noise()
	tile_map.generate(_map_heights, _max_terrain_height, _terrain_stretch, _do_not_clear)
	
func _read_noise():
	_map_heights.clear()
	for x in range(_terrain_length):
		var raw_noise : float = _noise.get_noise_1d(x)
		_map_heights.append(raw_noise)

func _generate_noise():
	_noise = FastNoiseLite.new()
	_noise.noise_type = noise_type
	_noise.seed = randi()
	_noise_texture.noise = _noise
	await _noise_texture.changed
	
	_noise_image = _noise_texture.get_image()
	_noise_image_data = _noise_image.get_data()
