extends Node2D

class DrawParams:
	var include_tags: Array[String] = []
	var exclude_tags: Array[String] = []
	var metadata_match: Dictionary[String, RegEx] = {}
	var type: String
	
	func _init(type_: String, include_tags_: Array[String]=[]):
		type = type_
		include_tags = include_tags_

class PoolItem:
	var id: String
	var type: String
	var weight: float = 1.0
	
	func _init(element: GameElement, weight_: float=1.0) -> void:
		id = element.id
		weight = weight_
		type = element.get_type()

var elements: Array[PoolItem] = []

func draw(params: DrawParams) -> GameElement:
	var candidates : Array[GameElement]
	var weights: PackedFloat32Array = []
	
	for e in elements:
		if params.type != e.type:
			continue
		
		# TODO: Implement other filters
		
		weights.append(e.weight)
		candidates.append(Database.get_element(e.id))
	
	if (candidates.is_empty()):
		return null
	if (candidates.size() == 1):
		return candidates[0]
	
	var rng = RandomNumberGenerator.new()
	
	return candidates[rng.rand_weighted(weights)]
	
func add(element: GameElement, weight: float = 1.0):
	elements.append(PoolItem.new(element, weight))
	
