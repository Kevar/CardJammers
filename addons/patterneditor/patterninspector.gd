extends EditorInspectorPlugin

var PropEditor = preload("res://addons/patterneditor/patternproperty.gd")

func _can_handle(object):
	return object is Pattern
	
func _parse_property(object, type, name, hint_type, hint_string, usage_flags, wide):
	if type == TYPE_INT:
		add_property_editor(name, PropEditor.new())
		return true
	else:
		return false
