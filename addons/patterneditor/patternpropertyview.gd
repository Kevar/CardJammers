@tool
extends GridContainer

signal pattern_changed(new_pattern:int)

func _ready():
	for i in range (0, 25):
		var cb:CheckBox = CheckBox.new()
		add_child(cb)
		cb.toggled.connect(_on_check_box_toggled)

func set_current_pattern(pattern:int):
	var i:int = 0
	
	for cb:CheckBox in get_children():
		if 1 << i & pattern == 1 << i:
			cb.button_pressed = true
		i += 1

func _on_check_box_toggled(toggled_on):
	var p:int = 0
	var i:int = 0
	
	for cb:CheckBox in get_children():
		if cb.button_pressed:
			p |= 1 << i
		i += 1
	
	pattern_changed.emit(p)
