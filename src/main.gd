class_name GameState
extends Node2D

@onready var main_view: Node2D = %MainView
@onready var map: Map = %Map
@onready var encounter: Encounter = %Encounter

func _on_map_location_entered(location: Location) -> void:
	map.hide()
	encounter.load_data(location.encounter)
	encounter.show()


func _on_encounter_on_exit() -> void:
	encounter.hide()
	map.show()
