@tool
extends Node2D

@export var noise_type : FastNoiseLite.NoiseType = FastNoiseLite.TYPE_SIMPLEX
@export var stretch : int

@export_tool_button("Update", "ArrowUp") var update_button = func(): _update_terrain()
@export_tool_button("Generate", "Reload") var regenerate_button = func(): _generate_terrain()

@export var max_terrain_height : int
@export var tile_map : TileMapLayer

var _noise_texture : NoiseTexture2D = NoiseTexture2D.new()
var _noise_image : Image
var _noise_image_data : PackedByteArray
var _map_heights : Array[float]
var _noise : FastNoiseLite

func _ready():
	_generate_terrain()
	$Sprite2D.texture = _noise_texture
	
func _generate_terrain():
	_generate_noise()
	_read_noise()
	tile_map.generate(_map_heights, max_terrain_height, stretch)
func _update_terrain():
	_read_noise()
	tile_map.generate(_map_heights, max_terrain_height, stretch)
	
func _read_noise():
	_map_heights.clear()
	for x in range(1280):
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
