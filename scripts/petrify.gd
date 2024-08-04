class_name Petrify
extends PowerEffect

var color: GameManager.CellState
var count: int
var petrified = []

func do():
	GameManager.API_board_cell_clicked().connect(on_cell_clicked)


func undo():
	for p in petrified:
		GameManager.API_set_board_cell(p[0], p[1], color - 2)


func on_cell_clicked(x, y):
	var state = GameManager.API_get_board_cell(x, y)
	if state == color:
		GameManager.API_set_board_cell(x, y, color + 2)
		petrified.append([x, y])
		if len(petrified) >= count:
			finish()
