@tool
extends Node2D
class_name Board

@export var cell_scene:PackedScene

@export_range(1, 20) var width:int = 4
@export_range(1, 20) var height:int = 4

@export var build:bool:
	get:
		return false
	set(value):
		_build_board()
		
func _build_board():
	for dc in get_children():
		dc.queue_free()
		
	if cell_scene == null:
		return
		
	var startX:int = -width * 64 / 2 + 32
	var startY:int = -height * 64 / 2 + 32
		
	for x in range(0, width):
		for y in range(0, width):
			var c:Node2D = cell_scene.instantiate()
			c.set_name("cell")
			add_child(c)
			c.set_owner(owner)
			c.position.x = startX + x * 64
			c.position.y = startY + y * 64
			
