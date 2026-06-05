class_name Encounter
extends Node2D

signal on_exit

@onready var data_label: RichTextLabel = %Data
@onready var background: TextureRect = %Background

var _encounter_data: EncounterData

func load_data(data:EncounterData):
	_encounter_data = data
	
	var result = Pool.draw(Pool.DrawParams.new(EventData.static_type()))
	var element = Database.get_element(result.id) as EventData
	
	background.texture = load("res://assets/%s" % element.background)

func _on_button_pressed() -> void:
	on_exit.emit()
