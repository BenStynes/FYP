class_name UnitPath
extends TileMap

export var grid: Resource

var _pathfinder: PathFinder

var current_path := PoolVector2Array()

func initialize(walkable_cells: Array) -> void:
	_pathfinder = PathFinder.new(grid,walkable_cells)
	
func draw(cell_start: Vector2, cell_end: Vector2) -> void:
	
	clear()
	current_path = _pathfinder.calculate_point_path(cell_start,cell_end)
	
	for cell in current_path:
		set_cellv(cell,0)
		
		update_bitmask_region()
		
func stop() -> void:
	_pathfinder = null;
	clear()
func _ready() -> void:
	# These two points define the start and the end of a rectangle of cells.
	var rect_start := Vector2(4, 4)
	var rect_end := Vector2(10, 8)

	# The following lines generate an array of points filling the rectangle from rect_start to rect_end.
	var points := []
	# In a for loop, writing a number or expression that evaluates to a number after the "in" 
	# keyword implicitly calls the range() function.
	# For example, "for x in 3" is a shorthand for "for x in range(3)".
	for x in rect_end.x - rect_start.x + 1:
		for y in rect_end.y - rect_start.y + 1:
			points.append(rect_start + Vector2(x, y))

	# We can use the points to generate our PathFinder and draw a path.
	initialize(points)
	
