extends Node2D

@onready var objectivesGrid:GridContainer = $Camera2D/CanvasLayer/Objectives
@onready var powerGrid:GridContainer = $Camera2D/CanvasLayer/Powers
@onready var globalActionButton:Button = $Camera2D/CanvasLayer/GlobalActionButton

@export var objectives:Array[Pattern]
@export var powers:Array[Power]

func _ready():
	var pV:PackedScene = load("res://scenes/pattern_view.tscn")
	
	for obj:Pattern in objectives:
		obj.compute_rotations()
		
		var pView:PatternView = pV.instantiate()
		pView.pattern = obj
		pView.check_pattern.connect(_on_pattern_view_check_pattern)
		objectivesGrid.add_child(pView)
		
	var powV:PackedScene = load("res://scenes/power_view.tscn")

	for pow:Power in powers:
		var powView:PowerView = powV.instantiate()
		powView.power = pow
		powerGrid.add_child(powView)
		powView.launchPower.connect(_on_launch_power)

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

func _on_launch_power(p: Power):
	var eff = Powers.dispatch(p.effect, GameManager.currentPlayer + 1)
	if eff:
		print("Launch power: " + str(p.effect))
		eff.do()
		eff.done.connect(func(): _on_power_done(eff))
	else:
		print("Could not launch power: " + str(p.effect))

func _on_power_done(p: PowerEffect):
	p.queue_free()
