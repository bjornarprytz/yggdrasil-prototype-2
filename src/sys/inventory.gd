class_name Inventory
extends Resource

signal item_equipped(item: ItemData)

@export var head: HeadData
@export var chest: ChestData
@export var left_hand: WeaponData
@export var right_hand: WeaponData
@export var legs: LegsData
@export var trinket: TrinketData
@export var drape: DrapeData
@export var gloves: GlovesData
@export var neck: NeckData

func equip(item: ItemData) -> void:
	match item.slot():
		"head":    head    = item as HeadData
		"chest":   chest   = item as ChestData
		"legs":    legs    = item as LegsData
		"trinket": trinket = item as TrinketData
		"drape":   drape   = item as DrapeData
		"gloves":  gloves  = item as GlovesData
		"neck":    neck    = item as NeckData
		"hand":
			if not left_hand:
				left_hand = item as WeaponData
			else:
				right_hand = item as WeaponData
		_:
			push_warning("Inventory.equip: unknown slot '%s'" % item.slot())
	item_equipped.emit(item)

func all_equipped() -> Array[ItemData]:
	var items: Array[ItemData] = []
	for item: ItemData in [head, chest, left_hand, right_hand, legs, trinket, drape, gloves, neck]:
		if item:
			items.append(item)
	return items
