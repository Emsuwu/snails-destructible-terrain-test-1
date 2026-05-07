@tool
class_name TerrainTilemap
extends TileMapLayer
static var instance : TerrainTilemap

func _ready():
	instance = self

func generate(map_heights : Array[float], max_terrain_height : int = 255, stretch : int = 1, no_clear : bool = false):
	if !no_clear: clear()
	var stretched_by : int = 0
	
	for x in range (len(map_heights)):
		for i in range(stretch):
			var height : int = int(map_heights[x] * max_terrain_height)
			for y in range(int(height)):
				var cell_pos : Vector2i = Vector2i(stretched_by + x, -y)
				set_cell(cell_pos, 0, Vector2i(0,0))
			if stretch!=1: stretched_by += 1

func get_cell_positions() -> Array[Vector2]:
	var cell_positions : Array[Vector2]
	for cell in get_used_cells():
		cell_positions.append(Vector2(cell.x, cell.y))
	return cell_positions