class_name MapData
extends Resource

## The number of nodes in each layer (first and last layer are implicit (on node in each)
@export var layers: Array[int]

@export var weights: Dictionary[EncounterData.Type, float] = {
	EncounterData.Type.Start: 0.0,
	EncounterData.Type.Combat: 2.0,
	EncounterData.Type.Elite: 0.3,
	EncounterData.Type.Event: 1.0,
	EncounterData.Type.Shop: 0.5,
	EncounterData.Type.Boss: 0.0
}

func draw_encounter_type() -> EncounterData.Type:
	var rng = RandomNumberGenerator.new()
	
	return weights.keys()[rng.rand_weighted(weights.values())]
