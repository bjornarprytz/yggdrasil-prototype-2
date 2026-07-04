extends Node2D

class PoolItem:
	var id: String
	var type: String
	var weight: float = 1.0
	
	func _init(element: GameElement, weight_: float=1.0) -> void:
		id = element.id
		weight = weight_
		type = element.get_type()

## Array of PoolItem, indexed by id
var elements: Dictionary[String, Array] = {}

## Draw an element from the pool matching the filters. Returns null if no match.
func draw(filters: Database.Filters) -> GameElement:
	if elements.is_empty():
		push_warning("Trying to draw from empty pool")
		return null

	var candidates_and_weights = _get_candidates(filters)
	var results = _draw_n_from_candidates(candidates_and_weights, 1)
	
	if results.is_empty():
		push_warning("Trying to draw from pool with no matching candidates")
		return null
	
	var result = results[0]
	return result

## Draw n elements from the pool matching the filters. Returns as many as possible if not enough matches.
func draw_n(filters: Database.Filters, n: int) -> Array[GameElement]:
	if elements.is_empty():
		push_warning("Trying to draw from empty pool")
		return []

	var candidates_and_weights = _get_candidates(filters)
	var results = _draw_n_from_candidates(candidates_and_weights, n)

	return results

func remove(element_id: String) -> void:
	elements.erase(element_id)

func add(element: GameElement, weight: float = 1.0):
	if not elements.has(element.id):
		elements[element.id] = []
	elements[element.id].append(PoolItem.new(element, weight))

func _draw_n_from_candidates(candidates_and_weights: Array[Array], n: int) -> Array[GameElement]:
	assert(n > 0, "draw_n should be called with n > 0")
	var candidates: Array[GameElement] = candidates_and_weights[0]
	var weights: PackedFloat32Array = candidates_and_weights[1]

	if (candidates.size() <= n):
		return candidates

	var rng = RandomNumberGenerator.new()
	var results: Array[GameElement] = []
	for i in range(n):
		var index = rng.rand_weighted(weights)
		var result = candidates[index]
		candidates.remove_at(index)
		weights.remove_at(index)
		results.append(result)
	return results

func _get_candidates(filters: Database.Filters) -> Array[Array]:
	var candidates : Array[GameElement]
	var weights: PackedFloat32Array = []

	var matches = Database.query(filters)
	
	for e in matches:
		if not elements.has(e.id) or elements[e.id].is_empty():
			continue

		var pool_items = elements[e.id]
		for i in range(pool_items.size()):
			var item = pool_items[i]
			weights.append(item.weight)
			candidates.append(Database.get_element(item.id))
	
	return [candidates, weights]

	
