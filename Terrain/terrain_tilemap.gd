@tool

extends TileMapLayer

func generate(map_heights : Array[float], max_terrain_height : int = 255, stretch : int = 1):
	clear()
	
	for x in range (len(map_heights)):
		for i in range(stretch):
			var height : int = int(map_heights[x] * max_terrain_height)
			for y in range(int(height)):
				var cell_pos : Vector2i = Vector2i(x, -y)
				set_cell(cell_pos, 0, Vector2i(0,0))
