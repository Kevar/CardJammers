class_name Powers
extends Node


enum Kind {
	PETRIFY_TWO,
}


static func dispatch(kind: Kind, color: GameManager.CellState) -> PowerEffect:
	match kind:
		Kind.PETRIFY_TWO: return petrify(color, 2)
	return null

static func petrify(color: GameManager.CellState, count: int) -> PowerEffect:
	if GameManager.API_board_count_cells(color) < count:
		return null
	var action = Petrify.new()
	action.color = color
	action.count = count
	GameManager.add_child(action)
	return action
