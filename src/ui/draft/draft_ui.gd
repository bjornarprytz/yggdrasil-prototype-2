class_name DraftUI
extends CanvasLayer

signal completed

var _picks_remaining: int
var _player: Player

func setup(draft: Draft, player: Player) -> void:
	layer = 10
	_player = player
	_picks_remaining = draft.pick_count

	var bg := ColorRect.new()
	bg.color = Color(0.05, 0.05, 0.1, 0.92)
	bg.size = Vector2(1280, 720)
	add_child(bg)

	var title := Label.new()
	title.text = "Draft — pick %d" % draft.pick_count
	title.position = Vector2(540, 160)
	add_child(title)

	var candidates := Database.query(draft.filter)
	candidates.shuffle()
	var offered := candidates.slice(0, min(draft.offer_count, candidates.size()))

	if offered.is_empty():
		completed.emit()
		return

	var container := HBoxContainer.new()
	container.position = Vector2(140, 240)
	container.add_theme_constant_override("separation", 20)
	add_child(container)

	for element in offered:
		var item := element as ItemData
		if not item:
			continue
		var card := Create.item_card(item)
		card.custom_minimum_size = Vector2(200, 200)
		card.pressed.connect(_on_pick.bind(item, card))
		container.add_child(card)

func _on_pick(item: ItemData, card: ItemCard) -> void:
	card.disabled = true
	_player.inventory.equip(item)
	_picks_remaining -= 1
	if _picks_remaining <= 0:
		completed.emit()
