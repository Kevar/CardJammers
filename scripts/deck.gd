extends Node2D
class_name Deck

@export var cardScene:PackedScene
@export_range(1, 32) var cardCount:int = 4

@export var firstPlayer:bool = false
@export var color:Color

var activeDeck:bool = false

func _ready():
	if firstPlayer:
		GameManager.deck1 = self
		activeDeck = true
	else:
		GameManager.deck2 = self
		activeDeck = false
	
	for i in range(0, cardCount):
		var c:Card = cardScene.instantiate()
		c.position.y = i * 32
		c.z_index = i
		c.ownerDeck = self
		add_child(c)
		c.set_owner(owner)
	
