extends Node

signal outcome_applied(outcome: Outcome, rolled_amount: int)

func apply(outcome: Outcome, player: Player) -> void:
	var amount := _roll(outcome)
	match outcome.type:
		Outcome.Type.HEALTH_CHANGE:
			if amount < 0:
				player.health.damage(-amount)
			else:
				player.health.heal(amount)
		Outcome.Type.RESOURCE_CHANGE:
			player.resources[outcome.resource_type] = \
				player.resources.get(outcome.resource_type, 0) + amount
		Outcome.Type.ADD_ITEM:
			var item := Database.get_element(outcome.item_id) as ItemData
			if item:
				player.inventory.append(item)
			else:
				push_warning("OutcomeResolver: item not found: %s" % outcome.item_id)
		Outcome.Type.TRIGGER_ENCOUNTER:
			pass  # consumer handles via outcome_applied signal
		Outcome.Type.POOL_ADD:
			var element := Database.get_element(outcome.element_id)
			if element:
				Pool.add(element, outcome.pool_weight)
			else:
				push_warning("OutcomeResolver: element not found: %s" % outcome.element_id)
		Outcome.Type.POOL_REMOVE:
			Pool.remove(outcome.element_id)
	outcome_applied.emit(outcome, amount)

func apply_all(outcomes: Array[Outcome], player: Player) -> void:
	for outcome in outcomes:
		apply(outcome, player)

func _roll(outcome: Outcome) -> int:
	return randi_range(outcome.amount_min, outcome.amount_max)
