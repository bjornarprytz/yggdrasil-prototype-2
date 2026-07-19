class_name ItemCard
extends Button

func set_item(item: ItemData) -> void:
	self_modulate = Color(1, 1, 1, 1)
	text = item.label()
	icon = item.icon
	tooltip_text = item.tooltip_text()

func set_empty(label: String = "Empty") -> void:
	self_modulate = Color(1, 1, 1, 0.4)
	text = label
	icon = null
	tooltip_text = ""

func set_layout_horizontal() -> void:
	theme_type_variation = &"CompactItemCard"
	icon_alignment = HORIZONTAL_ALIGNMENT_LEFT
	vertical_icon_alignment = VERTICAL_ALIGNMENT_CENTER
	alignment = HORIZONTAL_ALIGNMENT_LEFT
	expand_icon = false
	clip_text = true
	autowrap_mode = TextServer.AUTOWRAP_OFF

func set_layout_vertical() -> void:
	theme_type_variation = &""
	icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vertical_icon_alignment = VERTICAL_ALIGNMENT_TOP
	alignment = HORIZONTAL_ALIGNMENT_CENTER
	expand_icon = true
	clip_text = false
	autowrap_mode = TextServer.AUTOWRAP_WORD
