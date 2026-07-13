extends Node

const ENEMIES_PATH: StringName = "res://data/enemies"
const EVENTS_PATH: StringName = "res://data/events"
const ITEMS_PATH: StringName = "res://data/items"


func get_all_paths() -> Array[String]:
	var paths: Array[String] = []
	paths.append_array(_enumerate_files(ENEMIES_PATH))
	paths.append_array(_enumerate_files(EVENTS_PATH))
	return paths

func load_enemies() -> Array[EnemyData]:
	var enemies: Array[EnemyData] = []
	for file in _enumerate_files(ENEMIES_PATH):
		var enemy: EnemyData = load(file) as EnemyData
		enemies.append(enemy)
	
	return enemies

func load_events() -> Array[EventData]:
	var events: Array[EventData] = []
	for file in _enumerate_files(EVENTS_PATH):
		var enemy: EventData = load(file) as EventData
		events.append(enemy)
	
	return events

func load_items() -> Array[ItemData]:
	var items: Array[ItemData] = []
	for file in _enumerate_files(ITEMS_PATH):
		var item: ItemData = load(file) as ItemData
		items.append(item)
	
	return items


func _enumerate_files(path: String) -> Array[String]:
	var paths: Array[String] = []
	
	for file in DirAccess.get_files_at(path):
		paths.append("%s/%s" % [path, file])
	
	return paths
