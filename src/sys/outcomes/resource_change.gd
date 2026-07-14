class_name ResourceChange
extends Outcome

## resource_type is the key into player.resources, with the special value
## "health" routing to player.health instead. Negative amounts deal damage / deduct.
@export var resource_type: String = "gold"
@export var amount_min: int = 0
@export var amount_max: int = 0

func resolve(context: GameContext) -> void:
	var amount := randi_range(amount_min, amount_max)
	if resource_type == "health":
		if amount < 0:
			context.player.health.damage(-amount)
		else:
			context.player.health.heal(amount)
	else:
		context.player.resources[resource_type] = \
			context.player.resources.get(resource_type, 0) + amount
