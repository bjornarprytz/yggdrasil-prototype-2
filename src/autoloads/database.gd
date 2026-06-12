extends Node2D

class Filters:
	var include_tags: Array[String] = []
	var exclude_tags: Array[String] = []
	var metadata_match: Dictionary[String, RegEx] = {}
	var type: String
	
	func _init(type_: String, include_tags_: Array[String]=[], exclude_tags_: Array[String]=[], metadata_match_: Dictionary[String, RegEx]={}) -> void:
		type = type_
		include_tags = include_tags_
		exclude_tags = exclude_tags_
		metadata_match = metadata_match_

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

func query(filters: Filters) -> Array[GameElement]:
	var results: Array[GameElement] = []
	
	for e in _elements.values():
		if filters.type != e.get_type():
			continue
		
		var has_all_include_tags = true
		for t in filters.include_tags:
			if not e.tags.has(t):
				has_all_include_tags = false
				break
		if not has_all_include_tags:
			continue

		var has_any_exclude_tags = false
		for t in filters.exclude_tags:
			if e.tags.has(t):
				has_any_exclude_tags = true
				break
		if has_any_exclude_tags:
			continue

		var metadata_match = true
		for key in filters.metadata_match:
			if not e.metadata.has(key):
				metadata_match = false
				break
			if not filters.metadata_match[key].search(e.metadata[key]):
				metadata_match = false
				break
		if not metadata_match:
			continue

		results.append(e)

	return results
