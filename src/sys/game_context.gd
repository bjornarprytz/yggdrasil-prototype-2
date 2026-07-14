class_name GameContext
extends RefCounted

var player: Player
var pending_encounters: Array[EncounterData] = []
var pending_drafts: Array[Draft] = []

func _init(p: Player) -> void:
	player = p
