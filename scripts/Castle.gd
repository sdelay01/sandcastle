extends TileMap

signal decrease_build
const ROCKS = 12
const TOWER1 = 9
const TOWER2 = 8
const TOWER3 = 7
const HOLE1 = 10

func _ready():
	for x in range(0, 11):
		set_cellv(Vector2(x, 2), ROCKS)
	
func initCastle():
	set_cellv(Vector2(5, 5), TOWER3)
	set_cellv(Vector2(5, 6), TOWER3)
	set_cellv(Vector2(5, 7), TOWER3)
	
func lowerBuilding(cell):
	if   get_cellv(cell) == TOWER1: lowerCell(cell, -1)
	elif get_cellv(cell) == TOWER2: lowerCell(cell, TOWER1)
	elif get_cellv(cell) == TOWER3: lowerCell(cell, TOWER2)
	elif get_cellv(cell) == HOLE1: lowerCell(cell, -1)

func lowerCell(cell, index):
	set_cellv(cell, index)
	emit_signal("decrease_build")
