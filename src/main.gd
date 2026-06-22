class_name GameState
extends Node2D

@onready var map: Map = %Map
@onready var encounter: Encounter = %Encounter
@onready var player: Player = %Player

@onready var health_label: RichTextLabel = %Health

func _ready() -> void:
	var screen: LoadingScreen = preload("res://loading_screen/loading_screen.tscn").instantiate()
	add_child(screen)
	screen.loading_complete.connect(_on_loading_complete.bind(screen))
	screen.start(DataLoader.get_all_paths())

func _on_loading_complete(screen: LoadingScreen) -> void:
	for element in DataLoader.load_events():
		Database.add_element(element)
		Pool.add(element)

	for element in DataLoader.load_enemies():
		Database.add_element(element)
		Pool.add(element)

	_update_health_label()
	player.health.changed.connect(_on_health_changed)
	screen.queue_free()

func _on_map_location_entered(location: Location) -> void:
	map.hide()
	encounter.load_data(location.encounter)
	encounter.show()

func _on_encounter_on_exit() -> void:
	encounter.hide()
	map.show()

func _update_health_label():
	var max_health = player.health.max_health
	health_label.text = "%d/%d" % [player.health.current_health, max_health]

func _on_health_changed(_new_health: int, change: int) -> void:
	_update_health_label()

	var positive = change > 0
	if positive:
		health_label.self_modulate = Color(0, 1, 0)
	else:		
		health_label.self_modulate = Color(1, 0, 0)

	var t = create_tween()
	t.tween_property(health_label, "self_modulate", Color(1, 1, 1), 0.2)
