extends Button
class_name PowerView

@export var power:Power

signal launchPower(p: Power)

func _ready():
	text = power.description
	pressed.connect(launch)


func launch():
	launchPower.emit(power)
