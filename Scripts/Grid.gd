extends TileMap

enum CellType {ACTOR,OBSTACLE,OBJECT}

var tile_size = get_cell_size()

var tile_offset = Vector2(0,tile_size.y/2)

var grid_size = Vector2(16,16)

var grid = []

onready var Obstacle = preload("res://Obstical.tscn")
onready var Player = preload("res://Player.tscn")
onready var Enemy = preload("res://Enemy.tscn")

onready var Sorter = get_child(0)

onready var new_player = Player.instance()

func _ready():
	for child in get_children():
		set_cellv(world_to_map(child.position), child.type)
		
func get_cell_pawn(cell, type = CellType.ACTOR):
	for node in get_children():
		if node.type != type:
			continue
		if world_to_map(node.position) == cell:
			return(node)
	
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
	


