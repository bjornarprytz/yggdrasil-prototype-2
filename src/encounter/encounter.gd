class_name Encounter
extends Node2D

signal on_exit

@onready var data_label: RichTextLabel = %Data
@onready var background: TextureRect = %Background
@onready var enemy_container: Node2D = %EnemyContainer

var _encounter_data: EncounterData

func load_data(data:EncounterData):
	_encounter_data = data

	if _encounter_data.type == EncounterData.Type.Event:
		load_event()
	
	if _encounter_data.type == EncounterData.Type.Combat:
		load_combat()
	

func _on_button_pressed() -> void:
	on_exit.emit()
	cleanup()

func cleanup():
	data_label.text = ""
	background.texture = null
	for child in enemy_container.get_children():
		child.queue_free()


func load_event():
	var result = Pool.draw(Database.Filters.new(EventData.static_type()))
	var element = Database.get_element(result.id) as EventData

	data_label.text = element.intro_text
	
	background.texture = element.background

func load_combat():
	var result = Pool.draw(Database.Filters.new(EnemyData.static_type()))
	var element = Database.get_element(result.id) as EnemyData

	var enemy = Create.enemy(element)
	enemy_container.add_child(enemy)
