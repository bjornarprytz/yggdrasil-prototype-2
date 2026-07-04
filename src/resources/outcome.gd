class_name Outcome
extends Resource

enum Type {
	HEALTH_CHANGE,
	RESOURCE_CHANGE,
	ADD_ITEM,
	TRIGGER_ENCOUNTER,
	POOL_ADD,
	POOL_REMOVE,
}

@export var type: Type

# HEALTH_CHANGE, RESOURCE_CHANGE: rolled value in [amount_min, amount_max]
# Negative = damage / loss, positive = heal / gain
@export var amount_min: int = 0
@export var amount_max: int = 0

@export var resource_type: String = ""        # RESOURCE_CHANGE
@export var item_id: String = ""              # ADD_ITEM
@export var encounter_type: EncounterData.Type = EncounterData.Type.Event  # TRIGGER_ENCOUNTER
@export var element_id: String = ""           # POOL_ADD, POOL_REMOVE
@export var pool_weight: float = 1.0          # POOL_ADD
