class_name Sfx
extends Node2D


enum {
	CLICK,
	PLAY_CARD,
	GRAB_OBJECTIVE,
	PLACE_STONE,
}

@onready
var sounds = {
	CLICK: $Click,
	PLAY_CARD: $PlayCard,
	GRAB_OBJECTIVE: $GrabObjective,
	PLACE_STONE: $PlaceStone,
}

func _ready():
	pass

func play(id):
	if id in sounds:
		sounds[id].play()
