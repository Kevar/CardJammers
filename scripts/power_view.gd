extends Button
class_name PowerView

@export var power:Power

func _ready():
	text = power.description
