@tool

extends TileMapLayer

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
