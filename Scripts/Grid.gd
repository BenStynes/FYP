extends TileMap

enum {PLAYER,OBSTACLE,ENEMY}

var tile_size = get_cell_size()

var tile_offset = Vector2(0,tile_size.y/2)

var grid_size = Vector2(16,16)

var grid = []

onready var Obstacle = preload("res://Obstical.tscn")
onready var Player = preload("res://Player.tscn")
onready var Enemy = preload("res://Enemy.tscn")

onready var Sorter = get_child(0)



func _ready():
	randomize()
	for x in range(grid_size.x):
		grid.append([])
		for y in range(grid_size.y):
			grid[x].append(null)
			
	var new_player = Player.instance()
	new_player.position = map_to_world(Vector2(4,4)) + tile_offset
	Sorter.add_child(new_player)
	
	var positions = []
	for x in range(5):
		var placed = false
		while not placed:
			var grid_pos = Vector2(randi() % int(grid_size.x), randi() % int(grid_size.y))
			if not grid[grid_pos.x][grid_pos.y]:
				if not grid_pos in positions:
					positions.append(grid_pos)
					placed = true
		
	for pos in positions:
		var new_obstacle = Obstacle.instance()
		new_obstacle.position = map_to_world(pos) + tile_offset	
		grid[pos.x][pos.y] = new_obstacle.get_name()
		Sorter.add_child(new_obstacle)
	
	var positions2 = []
	for x in range(2):
		var placed = false
		while not placed:
			var grid_pos = Vector2(randi() % int(grid_size.x), randi() % int(grid_size.y))
			if not grid[grid_pos.x][grid_pos.y]:
				if not grid_pos in positions2:
					positions2.append(grid_pos)
					placed = true
		
	for pos in positions2:
		var new_enemy = Enemy.instance()
		new_enemy.position = map_to_world(pos) + tile_offset	
		grid[pos.x][pos.y] = new_enemy.get_name()
		Sorter.add_child(new_enemy)
		
func get_cell_content(pos=Vector2()):
	return grid[pos.x][pos.y]
	
func is_cell_vacant(pos=Vector2(), direction=Vector2()):
	var grid_pos = world_to_map(pos) + direction
	
	if grid_pos.x < grid_size.x and grid_pos.x >= 0:
		if grid_pos.y < grid_size.y and grid_pos.y >= 0:
			return true if grid[grid_pos.x][grid_pos.y] == null else false
	return false
	
func update_child_pos(pos,direction,type):
	var grid_pos = world_to_map(pos)
	grid[grid_pos.x][grid_pos.y] = null

	var new_grid_pos = grid_pos + direction
	grid[new_grid_pos.x][new_grid_pos.y] = type

	var target_pos = map_to_world(new_grid_pos) + tile_offset
	return target_pos
	
	
func is_cell_of_type(pos=Vector2(),type=null):
	var grid_pos = world_to_map(pos)
	return true if grid[grid_pos.x][grid_pos.y] == type else false

