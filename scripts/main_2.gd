extends Node2D

@onready var objectivesGrid:GridContainer = $Camera2D/CanvasLayer/Objectives
@onready var powerGrid:GridContainer = $Camera2D/CanvasLayer/Powers
@onready var globalActionButton:Button = $Camera2D/CanvasLayer/GlobalActionButton
@onready var player2SpecialMoveButton:Button = $Camera2D/CanvasLayer/Player2SpecialMove
@onready var player1ObjectivesCount:Label = $Camera2D/CanvasLayer/Player1ObjectivesCount
@onready var player2ObjectivesCount:Label = $Camera2D/CanvasLayer/Player2ObjectivesCount

@onready var winScreen:ColorRect = $Camera2D/CanvasLayer/WinScreen
@onready var winText:RichTextLabel = $Camera2D/CanvasLayer/WinScreen/WinText

@export var objectives:Array[Pattern]
@export var powers:Array[Power]

func _ready():
	GameManager.gameOver.connect(on_game_over)
	
	var pV:PackedScene = load("res://scenes/pattern_view.tscn")
	
	for obj:Pattern in objectives:
		obj.compute_rotations()
		
		var pView:PatternView = pV.instantiate()
		pView.pattern = obj
		pView.check_pattern.connect(_on_pattern_view_check_pattern)
		objectivesGrid.add_child(pView)
		
	var powV:PackedScene = load("res://scenes/power_view.tscn")

	for po:Power in powers:
		var powView:PowerView = powV.instantiate()
		powView.power = po
		powerGrid.add_child(powView)

func _process(_delta):
	if GameManager.currentPlayerCanPlayAStone:
		globalActionButton.text = "Player " + str(GameManager.currentPlayer + 1) + ": play a stone"
		globalActionButton.disabled = true
	else:
		globalActionButton.text = "Next player"
		globalActionButton.disabled = false
		
	if GameManager.specialMovePlayed:
		player2SpecialMoveButton.visible = false
	elif GameManager.currentPlayerCanPlayAStone and GameManager.currentPlayer == 1:
		player2SpecialMoveButton.disabled = false
		player2SpecialMoveButton.text = "Put a petrified stone" if GameManager.currentPlayerPlaySpecialMove else "Special move"
	else:
		player2SpecialMoveButton.disabled = true
		player2SpecialMoveButton.text = "Special move"
		
	player1ObjectivesCount.text = str(GameManager.player1ObjectivesCount) + " Objectives"
	player2ObjectivesCount.text = str(GameManager.player2ObjectivesCount) + " Objectives"

func _on_global_action_button_pressed():
	GameManager.next_player()

func _on_pattern_view_check_pattern(p:PatternView):
	if !GameManager.currentPlayerCanCheckAPattern:
		print("Can't check another pattern")
		return
		
	if p != null:
		if GameManager.API_find_and_stone_pattern(p.pattern, GameManager.currentPlayer + 1):
			p.capturedByPlayer = GameManager.currentPlayer
			GameManager.add_objective(GameManager.currentPlayer)
			GameManager.currentPlayerCanCheckAPattern = false
			print("Pattern found")
		else:
			print("Pattern not found")

func _on_player_2_special_move_pressed():
	GameManager.currentPlayerPlaySpecialMove = !GameManager.currentPlayerPlaySpecialMove

func on_game_over(winner:int):
	winScreen.visible = true
	winText.text = "[center]Player " + str(winner + 1) + " Wins![/center]"

func _on_play_again_pressed():
	get_tree().change_scene_to_file("res://scenes/main_2.tscn")
