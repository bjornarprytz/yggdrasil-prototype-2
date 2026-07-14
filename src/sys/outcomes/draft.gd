class_name Draft
extends Outcome

@export var filter: DatabaseFilter = DatabaseFilter.new(ItemData.static_type())
@export var offer_count: int = 3
@export var pick_count: int = 1

func resolve(context: GameContext) -> void:
	context.pending_drafts.append(self)
