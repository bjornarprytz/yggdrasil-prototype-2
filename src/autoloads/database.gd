extends Node2D

var items: Dictionary[String, ItemData] = {}
var encounters: Dictionary[String, EncounterData] = {}
var enemies: Dictionary[String, EnemyData] = {}


func get_element(id: String) -> GameElement:
	if items.has(id):
		return items[id]
	if encounters.has(id):
		return encounters[id]
	if enemies.has(id):
		return enemies[id]
	
	push_error("Asked for non-existent element: %s" % id)
	return null
	
