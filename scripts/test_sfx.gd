extends Node2D


func _ready():
	$Click.pressed.connect(play_click)
	$GrabObjective.pressed.connect(play_grab_objective)


func play_click():
	$Sfx.play(Sfx.CLICK)


func play_grab_objective():
	$Sfx.play(Sfx.GRAB_OBJECTIVE)
