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
	PLAYER2 = 2,
	PLAYER1_STONE = 3,
	PLAYER2_STONE = 4
}

var cellColors:Array[Color]

var boardWidth:int
var boardHeight:int

var board:Array[CellState]

var currentPlayer:int = 0
var currentPlayerCanPlayAStone:bool = true
var currentPlayerCanCheckAPattern:bool = false

signal updatePatternViewButtons

func init_board(width:int, height:int, p1Color:Color, p2Color:Color):
	boardWidth = width
	boardHeight = height
	
	cellColors.append(Color.WHITE)
	cellColors.append(p1Color)
	cellColors.append(p2Color)
	cellColors.append(p1Color * Color.DIM_GRAY)
	cellColors.append(p2Color * Color.DIM_GRAY)
	
	for x in range(0, width):
		for y in range(0, height):
			board.append(CellState.FREE)

func API_get_board_cell(x:int, y:int) -> CellState:
	if x < 0 or y < 0 or x >= boardWidth or y >= boardHeight:
		return CellState.FREE
	
	var index = x + y * boardWidth
	var res:CellState = board[index]
	return res

func API_set_board_cell(x:int, y:int, state:CellState):
	board[x + y * boardWidth] = state

func click_board_cell(x:int, y:int):
	var state = API_get_board_cell(x, y)
	
	if state == CellState.FREE and currentPlayerCanPlayAStone:
		API_set_board_cell(x, y, 1 + currentPlayer)
		#currentPlayer = 1-currentPlayer
		currentPlayerCanPlayAStone = false
		currentPlayerCanCheckAPattern = true
		updatePatternViewButtons.emit()

func next_player():
	currentPlayer = 1-currentPlayer
	currentPlayerCanPlayAStone = true
	currentPlayerCanCheckAPattern = false
	updatePatternViewButtons.emit()

func API_find_pattern(pattern:Pattern, state:CellState) -> Vector2i:
	var pBits:Array[int]
	
	pBits.append(pattern.bits)
	pBits.append(pattern.rotate90)
	pBits.append(pattern.rotate180)
	pBits.append(pattern.rotate270)
	
	for p in pBits:
		var r:Vector2i = find_sub_pattern(p, state)
		if r.x != -10:
			return r
			
	return Vector2i(-10, -10)

func API_find_and_stone_pattern(pattern:Pattern, state:CellState) -> bool:
	var pBits:Array[int]
	
	pBits.append(pattern.bits)
	pBits.append(pattern.rotate90)
	pBits.append(pattern.rotate180)
	pBits.append(pattern.rotate270)
	
	for p in pBits:
		var r:Vector2i = find_sub_pattern(p, state)
		if r.x != -10:
			stone_pattern_at(p, state, r.x, r.y)
			return true
			
	return false

func find_sub_pattern(pattern_bits:int, state:CellState) -> Vector2i:
	
	var pv1:Pattern = Pattern.new()
	pv1.bits = pattern_bits
			
	for x in range(-4, boardWidth):
		for y in range(-4, boardHeight):
			var p:int = extract_pattern(x, y, state)
			
			var pv2:Pattern = Pattern.new()
			pv2.bits = p
	
			if p & pattern_bits == pattern_bits:
				return Vector2i(x, y)
	
	return Vector2i(-10, -10) #Mettre -1 crée des faux négatifs avec les patterns dans le coin supérieur gauche

func stone_pattern_at(pattern_bits:int, state:CellState, x:int, y:int):
	for ix in range(0, 5):
		for iy in range(0, 5):
			var index:int = ix + iy * 5
			var b:bool = pattern_bits & 1 << index == 1 << index
			
			if API_get_board_cell(x + ix, y + iy) == state and b:
				API_set_board_cell(x + ix, y + iy, state + 2)
	updatePatternViewButtons.emit()
	
func extract_pattern(x:int, y:int, state:CellState) -> int:
	var pattern:int = 0
	
	for ix in range(0, 5):
		for iy in range(0, 5):
			if API_get_board_cell(x + ix, y + iy) == state:
				pattern |= 1 << (ix + iy * 5)
	
	return pattern
