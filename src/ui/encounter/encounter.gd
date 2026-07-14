class_name Encounter
extends Node2D

signal resolved(outcomes: Array[Outcome])

@onready var _data_label: RichTextLabel = %Data
@onready var _background: TextureRect = %Background
@onready var _exit_button: Button = $Button

var _options_container: VBoxContainer
var _player: Player
var _arena: CombatArena

func _ready() -> void:
	_options_container = VBoxContainer.new()
	_options_container.position = Vector2(19, 400)
	add_child(_options_container)

func start(data: EncounterData, player: Player) -> void:
	_player = player
	_cleanup()
	match data.type:
		EncounterData.Type.Start:
			resolved.emit([] as Array[Outcome])
		EncounterData.Type.Event:
			_start_event()
		EncounterData.Type.Combat:
			_start_combat([])
		EncounterData.Type.Elite:
			_start_combat(["elite"])
		EncounterData.Type.Boss:
			_start_combat(["boss"])
		EncounterData.Type.Shop:
			_data_label.text = "Shop (coming soon)"
			_exit_button.show()

func _start_event() -> void:
	var event := Pool.draw(Database.Filters.new(EventData.static_type())) as EventData
	if event == null:
		push_error("Encounter: no events in pool")
		resolved.emit([] as Array[Outcome])
		return
	_data_label.text = event.intro_text
	_background.texture = event.background
	for option in event.options:
		var btn := Button.new()
		btn.text = option.label
		btn.pressed.connect(_resolve_with.bind(option.outcomes))
		_options_container.add_child(btn)
	if event.options.is_empty():
		_exit_button.show()
	else:
		_exit_button.hide()

func _start_combat(required_tags: Array[String]) -> void:
	var filters := Database.Filters.new(EnemyData.static_type())
	filters.include_tags = required_tags
	var enemy_data := Pool.draw(filters) as EnemyData
	if enemy_data == null:
		push_error("Encounter: no matching enemies in pool")
		resolved.emit([] as Array[Outcome])
		return
	_data_label.hide()
	_exit_button.hide()
	_arena = preload("res://ui/combat/combat_arena.tscn").instantiate()
	_arena.setup(enemy_data, _player)
	_arena.completed.connect(_on_combat_completed)
	add_child(_arena)

func _on_combat_completed(outcomes: Array[Outcome]) -> void:
	_arena.queue_free()
	_arena = null
	_data_label.show()
	resolved.emit(outcomes)

func _resolve_with(outcomes: Array[Outcome]) -> void:
	_cleanup()
	resolved.emit(outcomes)

func _on_button_pressed() -> void:
	_cleanup()
	resolved.emit([] as Array[Outcome])

func _cleanup() -> void:
	_data_label.text = ""
	_data_label.show()
	_background.texture = null
	_exit_button.show()
	if _arena != null:
		_arena.queue_free()
		_arena = null
	for child in _options_container.get_children():
		child.queue_free()
