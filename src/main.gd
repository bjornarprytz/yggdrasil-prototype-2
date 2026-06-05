class_name GameState
extends Node2D

@onready var main_view: Node2D = %MainView
@onready var map: Map = %Map
@onready var encounter: Encounter = %Encounter

@onready var game_elements = preload("res://assets/game-elements.csv")

func _ready() -> void:
	for r in game_elements.records:
		var element = GameElementParser.parse(r)
		Database.add_element(element)
		Pool.add(element)
	pass

func _on_map_location_entered(location: Location) -> void:
	map.hide()
	encounter.load_data(location.encounter)
	encounter.show()

func _on_encounter_on_exit() -> void:
	encounter.hide()
	map.show()
