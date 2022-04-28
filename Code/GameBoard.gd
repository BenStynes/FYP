class_name GameBoard
extends Node2D

const DIRECTIONS = [Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN]
var Turn = 0
export var grid: Resource = preload("res://Grid.tres")
var Count = 0
var _units := {}
var _active_unit: Unit
var _walkable_cells := []
var _walkable_cellsE := []
var _enemies := {}
var _active_Enemy: Enemy
var enemyarray = []

onready var _unit_overlay: UnitOverlay = $UnitOverlay
onready var _enemy_overlay: UnitOverlay = $UnitOverlay
onready var _unit_path: UnitPath = $UnitPath
onready var _enemy_path: UnitPath = $UnitPath

func _ready() -> void:
	Turn = 0
	_reinitialize()
		
	
func is_occupied(cell: Vector2) -> bool:
	return true if _units.has(cell) or _enemies.has(cell) else false

func _reinitialize() -> void:
	_units.clear()
	_enemies.clear()
	for child in get_children():
		
		var unit := child as Unit
		if not unit:
			continue
		
		_units[unit.cell] = unit
	
	for child in get_children():
		var enemy := child as Enemy
		if not enemy:
			continue
		
		_enemies[enemy.cell] = enemy
		enemyarray.push_back(enemy)
	
func get_walkable_cells(unit: Unit) -> Array:
	return _flood_fill(unit.cell, unit.move_range)
func get_walkable_cellsE(enemy: Enemy) -> Array:
	return _flood_fill(enemy.cell, enemy.move_range-1)
func _process(delta):
	
	if Turn == 0:
	 
		if Count >= 2:
			Turn = 1
			Count = 0
			for child in get_children():
		
				var unit := child as Unit
				if not unit:
					continue
		
				_units[unit.cell] = unit
				unit.moved = false
		
	if Turn == 1:
		var playerPos
		var ePos
		for child in get_children():
		
				var unit := child as Unit
				if not unit:
					continue
		
				_units[unit.cell] = unit
				playerPos = unit
				
		for child in get_children():
			var enemy := child as Enemy
			
			if not enemy:
				continue
			
			_enemies[enemy.cell] = enemy
			
			enemy.moved = false
			
		if Count == 0:
			_select_enemy(enemyarray[0].cell)
			_move_active_enemy(Vector2(playerPos.cell.x-1 ,playerPos.cell.y))	
		if Count == 1:
			_select_enemy(enemyarray[1].cell)
			_move_active_enemy(Vector2(playerPos.cell.x ,playerPos.cell.y-1))	
		if Count >= 2:
			Turn = 0
			Count = 0
			
	
func _flood_fill(cell: Vector2, max_distance: int) -> Array:

	var array := []

	var stack := [cell]

	while not stack.empty():
		var current = stack.pop_back()

		if not grid.is_within_bounds(current):
			continue
		if current in array:
			continue


		var difference: Vector2 = (current - cell).abs()
		var distance := int(difference.x + difference.y)
		if distance > max_distance:
			continue


		array.append(current)

		for direction in DIRECTIONS:
			var coordinates: Vector2 = current + direction
			
			if is_occupied(coordinates):
				continue
			if coordinates in array:
				continue

			
			stack.append(coordinates)
	return array
func _select_unit(cell: Vector2) -> void:
	if not _units.has(cell):
		return
	if _units[cell].moved == false:
		_active_unit = _units[cell]
		_active_unit.is_selected = true
		_walkable_cells = get_walkable_cells(_active_unit)
		_unit_overlay.draw(_walkable_cells)
		_unit_path.initialize(_walkable_cells)
	return

func _deselect_active_unit() -> void:
	_active_unit.is_selected = false
	_unit_overlay.clear()
	_unit_path.stop()
	
func _clear_active_unit() -> void:
	_active_unit = null
	_walkable_cells.clear()

func _move_active_unit(new_cell: Vector2) -> void:
	if is_occupied(new_cell) or not new_cell in _walkable_cells:
		return
		
	_units.erase(_active_unit.cell)
	_units[new_cell] = _active_unit
	
	_deselect_active_unit()
	
	_active_unit.walk_along(_unit_path.current_path)
	yield(_active_unit, "walk_finished")
	_active_unit.moved = true
	Count = Count +1
	_clear_active_unit()

func _on_Cursor_accept_pressed(cell: Vector2) -> void:
	if not _active_unit:
		_select_unit(cell)
	elif _active_unit.is_selected:
		_move_active_unit(cell)
		
	
		
func _on_Cursor_moved(new_cell: Vector2) -> void:
	
	if _active_unit and _active_unit.is_selected:
		_unit_path.draw(_active_unit.cell, new_cell)


func _unhandled_input(event: InputEvent) -> void:
	if _active_unit and event.is_action_pressed("ui_cancel"):
		_deselect_active_unit()
		_clear_active_unit()
		
func _select_enemy(cell: Vector2) -> void:
	if not _enemies.has(cell):
		return
	if _enemies[cell].moved == false:
		_active_Enemy = _enemies[cell]
		_active_Enemy.is_enemyTurn = true
		_walkable_cellsE = get_walkable_cellsE(_active_Enemy)
		_enemy_overlay.draw(_walkable_cellsE)
		
		_enemy_path.initialize(_walkable_cellsE)
	return


func _deselect_active_enemy() -> void:
	_active_Enemy.is_enemyTurn = false
	_enemy_overlay.clear()
	_enemy_path.stop()
	
func _clear_active_enemy() -> void:
	
	_active_Enemy = null
	_walkable_cellsE.clear()

func _move_active_enemy(new_cell: Vector2) -> void:
	if is_occupied(new_cell) or not new_cell in _walkable_cellsE:
		Count = Count +1
		_active_Enemy.moved = true
		return
		
		
	_enemies.erase(_active_Enemy.cell)
	_enemies[new_cell] = _active_Enemy
	
	_deselect_active_enemy()
	
	_active_Enemy.walk_along(_enemy_path.current_path)
	_active_Enemy.moved = true
	yield(_active_Enemy, "walk_finished")
	Count = Count +1
	
	_clear_active_enemy()
