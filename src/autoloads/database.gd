extends Node2D

var _elements: Dictionary[String, GameElement] = {}

func add_element(element: GameElement):
	if (_elements.has(element.id)):
		push_warning("Trying to re-add existing element %s" % element.id)
	else:
		_elements[element.id] = element

func get_element(id: String) -> GameElement:
	if _elements.has(id):
		return _elements[id]
	
	push_error("Asked for non-existent element: %s" % id)
	return null
	
