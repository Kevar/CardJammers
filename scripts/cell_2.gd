extends Area2D
class_name Cell2

@onready var sprite:Sprite2D = $Sprite2D
@onready var coll:CollisionShape2D = $CollisionShape2D

var boardX:int = 0
var boardY:int = 0

var currentState:GameManager.CellState
var mouseOver:bool = false

func init_cell(x:int, y:int):
	boardX = x
	boardY = y

func _process(_delta):
	currentState = GameManager.API_get_board_cell(boardX, boardY)
	sprite.modulate = GameManager.cellColors[GameManager.currentPlayer + 3] if mouseOver and currentState == GameManager.CellState.FREE and GameManager.currentPlayerCanPlayAStone else GameManager.cellColors[currentState]

func _input(event):
	if currentState == GameManager.CellState.FREE and mouseOver and event is InputEventMouseButton:
		if event.is_pressed():
			GameManager.click_board_cell(boardX, boardY)

func getSizeX():
	return 32		#La collision n'existe pas encore quand on accède à cette info

func getSizeY():
	return 32

func _on_mouse_entered():
	mouseOver = true

func _on_mouse_exited():
	mouseOver = false
