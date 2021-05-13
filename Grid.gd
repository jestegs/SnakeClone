extends TileMap


enum {FLOOR=0, WALL=1, TAIL=2}
var grid_size:Vector2


func build_grid(size:Vector2):
	for y in size.y:
		for x in size.x:
			if x == 0 or x == size.x-1 or y == 0 or y == size.y-1:
				set_cell(x, y, WALL)
			else:
				set_cell(x, y, FLOOR)


func request_move(object, direction:Vector2):
	var curr_cell = world_to_map(object.position)
	var target_cell = get_cellv(curr_cell + direction)
	
	if target_cell == WALL or target_cell == TAIL:
		return false
	else:
		#object.position = target_cell.position
		object.position = map_to_world(curr_cell + direction)
		return true
