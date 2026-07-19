class_name InventoryUI
extends Control

@onready var slot_list: VBoxContainer = %SlotList
@onready var item_grid: GridContainer = %ItemGrid

var player: Player

func setup(p: Player) -> void:
	player = p
	player.inventory.item_equipped.connect(_on_inventory_changed)
	player.inventory.bag_changed.connect(_on_inventory_changed)
	refresh()

func _on_inventory_changed(_item: ItemData = null) -> void:
	refresh()

func refresh() -> void:
	if player == null:
		return
	_refresh_slots()
	_refresh_grid()

func _refresh_slots() -> void:
	for child in slot_list.get_children():
		child.queue_free()

	var inv := player.inventory
	var slots := {
		"Head": inv.head,
		"Chest": inv.chest,
		"Legs": inv.legs,
		"Gloves": inv.gloves,
		"Neck": inv.neck,
		"Drape": inv.drape,
		"Trinket": inv.trinket,
		"Left Hand": inv.left_hand,
		"Right Hand": inv.right_hand,
	}
	for slot_label in slots:
		var item: ItemData = slots[slot_label]
		var card: ItemCard
		if item:
			card = Create.item_card(item)
			card.text = "%s: %s" % [slot_label, card.text]
		else:
			card = Create.empty_item_card("%s: Empty" % slot_label)
		card.set_layout_horizontal()
		card.custom_minimum_size = Vector2(0, 56)
		card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		slot_list.add_child(card)

func _refresh_grid() -> void:
	for child in item_grid.get_children():
		child.queue_free()

	for item: ItemData in player.inventory.bag:
		var card := Create.item_card(item)
		card.custom_minimum_size = Vector2(130, 130)
		item_grid.add_child(card)
