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

func query(filter: DatabaseFilter) -> Array[GameElement]:
	var results: Array[GameElement] = []

	for e in _elements.values():
		if filter.type != "" and filter.type != e.get_type():
			continue

		var has_all_include_tags := true
		for t in filter.include_tags:
			if not e.tags.has(t):
				has_all_include_tags = false
				break
		if not has_all_include_tags:
			continue

		var has_any_exclude_tags := false
		for t in filter.exclude_tags:
			if e.tags.has(t):
				has_any_exclude_tags = true
				break
		if has_any_exclude_tags:
			continue

		results.append(e)

	return results
