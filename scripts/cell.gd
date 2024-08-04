extends Area2D
class_name Cell

@onready
var sprite:Sprite2D = $Sprite2D

var mouseOver:bool = false

var occupied:bool = false

func _process(_delta):
	sprite.modulate = Color(1, 0.9, 0.8) if (!occupied and mouseOver) else Color.WHITE

func _on_mouse_entered():
	mouseOver = true
	GameManager.enter_current_cell(self)

func _on_mouse_exited():
	mouseOver = false
	GameManager.leave_current_cell(self)
