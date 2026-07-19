class_name GameState
extends Node2D

@onready var map: Map = %Map
@onready var encounter: Encounter = %Encounter
@onready var inventory_ui: InventoryUI = %Inventory
@onready var player: Player = %Player

@onready var health_label: RichTextLabel = %Health

func _ready() -> void:
	var screen: LoadingScreen = preload("res://ui/loading_screen/loading_screen.tscn").instantiate()
	add_child(screen)
	screen.loading_complete.connect(_on_loading_complete.bind(screen))
	screen.start(DataLoader.get_all_paths())
	player.inventory.item_equipped.connect(_on_item_equipped)
	inventory_ui.setup(player)

func _on_loading_complete(screen: LoadingScreen) -> void:
	for element in DataLoader.load_events():
		Database.add_element(element)
		Pool.add(element)

	for element in DataLoader.load_enemies():
		Database.add_element(element)
		Pool.add(element)

	for element in DataLoader.load_items():
		Database.add_element(element)
		Pool.add(element)

	_update_health_label()
	player.health.changed.connect(_on_health_changed)
	screen.queue_free()

func _on_map_location_entered(location: Location) -> void:
	if location.encounter.type == EncounterData.Type.Start:
		return
	map.hide()
	encounter.show()
	encounter.start(location.encounter, player)

func _on_encounter_resolved(outcomes: Array[Outcome]) -> void:
	var context := GameContext.new(player)
	OutcomeResolver.apply_all(outcomes, context)
	if not context.pending_encounters.is_empty():
		encounter.start(context.pending_encounters[0], player)
		return
	encounter.hide()
	if not context.pending_drafts.is_empty():
		_start_draft(context.pending_drafts[0])
		return
	map.show()

func _start_draft(draft: Draft) -> void:
	var draft_ui := DraftUI.new()
	add_child(draft_ui)
	draft_ui.setup(draft, player)
	draft_ui.completed.connect(_on_draft_completed.bind(draft_ui))

func _on_draft_completed(draft_ui: DraftUI) -> void:
	draft_ui.queue_free()
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


func _on_item_equipped(item: ItemData) -> void:
	print("Item equipped: %s" % item.id)

func _on_inventory_button_pressed() -> void:
	inventory_ui.visible = not inventory_ui.visible
	if inventory_ui.visible:
		inventory_ui.refresh()
