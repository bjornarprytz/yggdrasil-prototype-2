class_name AddItem
extends Outcome

@export var item_id: String = ""

func resolve(context: GameContext) -> void:
	var item := Database.get_element(item_id) as ItemData
	if not item:
		push_warning("AddItem: item not found: %s" % item_id)
		return
	context.player.inventory.equip(item)
