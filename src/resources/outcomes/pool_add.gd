class_name PoolAdd
extends Outcome

@export var element_id: String = ""
@export var pool_weight: float = 1.0

func resolve(_context: GameContext) -> void:
	var element := Database.get_element(element_id)
	if element:
		Pool.add(element, pool_weight)
	else:
		push_warning("PoolAdd: element not found: %s" % element_id)
