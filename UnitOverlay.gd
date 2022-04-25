class_name UnitOverlay
extends TileMap

func draw(cells: Array) -> void:
	clear()
   
	for cell in cells:
		set_cellv(cell, 0)
