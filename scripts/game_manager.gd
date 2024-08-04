extends Node

var hovered_cards:Array

var current_cell:Cell
var hovered_card:Card

var deck1:Deck
var deck2:Deck

func has_currentcell():
	return current_cell != null and !current_cell.occupied

func get_currentcell_pos() -> Vector2:
	return current_cell.global_position if has_currentcell() else Vector2(0, 0)

func put_card_on_currentcell(card:Card):
	if has_currentcell():
		card.initialPos = get_currentcell_pos()
		card.played = true
		current_cell.occupied = true
		
		if deck1.activeDeck:
			deck1.activeDeck = false
			deck2.activeDeck = true
		else:
			deck1.activeDeck = true
			deck2.activeDeck = false

func enter_current_cell(cell:Cell):
	current_cell = cell
	
func leave_current_cell(cell:Cell):
	if current_cell == cell:
		current_cell = null
		
func enter_card(card:Card):
	hovered_cards.push_back(card)
	find_hovered_card()
	
func leave_card(card:Card):
	hovered_cards.remove_at(hovered_cards.find(card))
	find_hovered_card()

func find_hovered_card():
	if len(hovered_cards) == 0:
		hovered_card = null
	else:
		hovered_card = hovered_cards[0]
		
		for i in range(1, len(hovered_cards)):
			if hovered_card.z_index < hovered_cards[i].z_index:
				hovered_card = hovered_cards[i]


#========================================================

enum CellState
{
	FREE = 0,
	PLAYER1 = 1,
	PLAYER2 = 2
}

var cellColors:Array[Color]

var boardWidth:int
var boardHeight:int

var board:Array[CellState]

var currentPlayer:int = 0

func init_board(width:int, height:int, p1Color:Color, p2Color:Color):
	
	boardWidth = width
	boardHeight = height
	
	cellColors.append(Color.WHITE)
	cellColors.append(p2Color)
	cellColors.append(p1Color)
	
	for x in range(0, width):
		for y in range(0, height):
			board.append(CellState.FREE)

func get_board_cell(x:int, y:int) -> CellState:
	var index = x + y * boardWidth
	var res:CellState = board[index]
	return res

func set_board_cell(x:int, y:int, state:CellState):
	board[x + y * boardWidth] = state

func click_board_cell(x:int, y:int):
	var state = get_board_cell(x, y)
	
	if state == CellState.FREE:
		set_board_cell(x, y, 1 + currentPlayer)
		currentPlayer = 1-currentPlayer
