#extends TileMap
#
#
#enum CellType { ACTOR, OBSTACLE, OBJECT }
#export(NodePath) var dialogue_ui
#
#func _ready():
#	for child in get_children():
#		set_cellv(world_to_map(child.position), child.type)
#
#
#func get_cell_pawn(cell, type = CellType.ACTOR):
#	for node in get_children():
#		if node.type != type:
#			continue
#		if world_to_map(node.position) == cell:
#			return(node)
#
#func request_move(pawn, direction):
#	var cell_start = world_to_map(pawn.position)
#	var cell_target = cell_start + direction
#
#	var cell_tile_id = get_cellv(cell_target)
#	match cell_tile_id:
#		-1:
#			set_cellv(cell_target, CellType.ACTOR)
#			set_cellv(cell_start, -1)
#			return map_to_world(cell_target) + cell_size / 2
#		CellType.OBJECT, CellType.ACTOR:
#			var target_pawn = get_cell_pawn(cell_target, cell_tile_id)
#			print("Cell %s contains %s" % [cell_target, target_pawn.name])
#
#			if not target_pawn.has_node("DialoguePlayer"):
#				return
#			get_node(dialogue_ui).show_dialogue(pawn, target_pawn.get_node("DialoguePlayer"))
#
#
class_name Grid
extends Resource

export var size := Vector2(20, 20)

export var cell_size := Vector2(80, 80)

var _half_cell_size = cell_size / 2


func calculate_map_position(grid_position: Vector2) -> Vector2:
	return grid_position * cell_size + _half_cell_size

func calculate_grid_coordinates(map_position: Vector2) -> Vector2:
	return (map_position / cell_size).floor()
	
func is_within_bounds(cell_coordinates: Vector2) -> bool:
	var out:= cell_coordinates.x >= 0 and cell_coordinates.x < size.x
	return out and cell_coordinates.y >= 0 and cell_coordinates.y < size.y

func clamp(grid_position: Vector2) -> Vector2:
	var out := grid_position
	out.x = clamp(out.x, 0, size.x - 1.0)
	out.y = clamp(out.y, 0, size.y - 1.0)
	return out
	
func as_index(cell: Vector2) -> int:
	return int(cell.x + size.x * cell.y)
