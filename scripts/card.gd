extends Area2D
class_name Card

@onready var sprite:Sprite2D = $Sprite2D
@onready var initialPos:Vector2 = global_position

var ownerDeck:Deck

var grabbed:bool = false
var deltaMouse:Vector2

var played:bool = false


func _process(_delta):
	if played:
		sprite.modulate = ownerDeck.color * Color(0.8, 0.8, 0.8)
	elif ownerDeck.activeDeck:
		sprite.modulate = ownerDeck.color * Color(1, 0.9, 0.8) if GameManager.hovered_card == self else ownerDeck.color
	else:
		sprite.modulate = ownerDeck.color * Color(0.5, 0.5, 0.5)
	
	if !played and grabbed:
		global_position = get_viewport().get_mouse_position() + deltaMouse
	else:
		global_position = initialPos
	
func _input(event):
	if event is InputEventMouseButton and !played and GameManager.hovered_card == self and ownerDeck.activeDeck:
		grabbed = event.pressed
		
		if grabbed:
			deltaMouse = global_position - get_viewport().get_mouse_position()
		elif GameManager.has_currentcell():
			GameManager.put_card_on_currentcell(self)
			

func _on_mouse_entered():
	GameManager.enter_card(self)

func _on_mouse_exited():
	GameManager.leave_card(self)
