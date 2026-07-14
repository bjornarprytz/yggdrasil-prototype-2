class_name GameContext
extends RefCounted

var player: Player
var pending_encounters: Array[EncounterData] = []

func _init(p: Player) -> void:
	player = p
