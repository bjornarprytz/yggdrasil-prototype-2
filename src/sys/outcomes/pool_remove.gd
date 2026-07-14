class_name PoolRemove
extends Outcome

@export var element_id: String = ""

func resolve(_context: GameContext) -> void:
	Pool.remove(element_id)
