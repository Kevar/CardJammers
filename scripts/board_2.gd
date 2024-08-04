extends Node2D

@export var cellScene:PackedScene

@export_range(4, 20) var width:int = 4
@export_range(4, 20) var height:int = 4

@export var player1Color:Color = Color.RED
@export var player2Color:Color = Color.BLUE

func _ready():
	GameManager.init_board(width, height, player1Color, player2Color)
	
	for x in range(0, width):
		for y in range(0, height):
			var c:Cell2 = cellScene.instantiate()
			c.position.x = (x - width / 2.0 + 0.5) * c.getSizeX()
			c.position.y = (y - height / 2.0 + 0.5) * c.getSizeY()
			add_child(c)
			c.init_cell(x, y)
