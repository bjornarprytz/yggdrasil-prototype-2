class_name TriggerEncounter
extends Outcome

@export var encounter_type: EncounterData.Type = EncounterData.Type.Event

func resolve(context: GameContext) -> void:
	context.pending_encounters.append(EncounterData.new(encounter_type))
