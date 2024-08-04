extends Button
class_name PatternView

@export var pattern:Pattern

@onready var grid:GridContainer = $GridContainer

signal check_pattern(p:PatternView)

var capturedByPlayer:int = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.updatePatternViewButtons.connect(on_updatePatternViewButtons)
	
	for i in range(0, 25):
		var c:ColorRect = ColorRect.new()
		c.color = Color.WHITE if pattern.get_bit_ati(i) else Color.TRANSPARENT
		#c.size.x = 24
		#c.size.y = 24
		c.mouse_filter = Control.MOUSE_FILTER_PASS
		c.size_flags_horizontal |= Control.SIZE_EXPAND
		c.size_flags_vertical |= Control.SIZE_EXPAND
		grid.add_child(c)
		
	disabled = true
	on_updatePatternViewButtons()

func on_updatePatternViewButtons():
	disabled = capturedByPlayer >= 0 or !GameManager.currentPlayerCanCheckAPattern or GameManager.API_find_pattern(pattern, GameManager.currentPlayer + 1).x == -10
	if capturedByPlayer >= 0:
		modulate = GameManager.cellColors[capturedByPlayer + 1]
	else:
		modulate = Color.DIM_GRAY if disabled else Color.WHITE

func _on_pressed():
	check_pattern.emit(self)
	on_updatePatternViewButtons()
