class_name Encounter
extends Node2D

signal on_exit

@onready var data_label: RichTextLabel = %Data

var _encounter_data: EncounterData

func load_data(data:EncounterData):
	_encounter_data = data
	data_label.text = _encounter_data.to_string()

func _on_button_pressed() -> void:
	on_exit.emit()
