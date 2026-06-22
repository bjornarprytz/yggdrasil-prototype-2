extends Node

const ENEMIES_PATH: StringName = "res://data/enemies"
const EVENTS_PATH: StringName = "res://data/events"


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


func _enumerate_files(path: String) -> Array[String]:
	var paths: Array[String] = []
	
	for file in DirAccess.get_files_at(path):
		paths.append("%s/%s" % [path, file])
	
	return paths
