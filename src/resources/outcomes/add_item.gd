class_name AddItem
extends Outcome

@export var item_id: String = ""

func resolve(context: GameContext) -> void:
	var item := Database.get_element(item_id) as ItemData
	if item:
		context.player.inventory.append(item)
	else:
		push_warning("AddItem: item not found: %s" % item_id)
