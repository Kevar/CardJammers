extends EditorProperty

var control = preload("res://addons/patterneditor/patternpropertyview.tscn").instantiate()

var updating:bool = false

func _init():
	add_child(control)
	add_focusable(control)
	control.pattern_changed.connect(on_pattern_changed)

func on_pattern_changed(new_pattern:int):
	if updating:
		return
		
	emit_changed(get_edited_property(), new_pattern)

func _update_property():
	updating = true
	control.set_current_pattern(get_edited_object()[get_edited_property()])
	updating = false
