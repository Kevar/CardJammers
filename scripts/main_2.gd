extends Node2D

@onready var grid:GridContainer = $Camera2D/CanvasLayer/GridContainer
@onready var globalActionButton:Button = $Camera2D/CanvasLayer/GlobalActionButton

@export var objectives:Array[Pattern]

func _ready():
	var pV:PackedScene = load("res://scenes/pattern_view.tscn")
	
	for obj:Pattern in objectives:
		obj.compute_rotations()
		
		var pView:PatternView = pV.instantiate()
		pView.pattern = obj
		pView.check_pattern.connect(_on_pattern_view_check_pattern)
		grid.add_child(pView)

func _process(_delta):
	if GameManager.currentPlayerCanPlayAStone:
		globalActionButton.text = "Player " + str(GameManager.currentPlayer + 1) + ": play a stone"
		globalActionButton.disabled = true
	else:
		globalActionButton.text = "Next player"	
		globalActionButton.disabled = false

func _on_global_action_button_pressed():
	GameManager.next_player()

func _on_pattern_view_check_pattern(p:PatternView):
	if !GameManager.currentPlayerCanCheckAPattern:
		print("Can't check another pattern")
		return
		
	if p != null:
		if GameManager.API_find_and_stone_pattern(p.pattern, GameManager.currentPlayer + 1):
			p.capturedByPlayer = GameManager.currentPlayer
			GameManager.currentPlayerCanCheckAPattern = false
			print("Pattern found")
		#var pos:Vector2i = GameManager.API_find_pattern(p.pattern, GameManager.currentPlayer + 1)
		#if pos.x >= 0:
		#	print("Pattern found at " + str(pos.x) + ":" + str(pos.y))
		#	GameManager.API_stone_pattern_at(p.pattern, GameManager.currentPlayer + 1, pos.x, pos.y)
		#	p.capturedByPlayer = GameManager.currentPlayer
		#	GameManager.currentPlayerCanCheckAPattern = false
		else:
			print("Pattern not found")
