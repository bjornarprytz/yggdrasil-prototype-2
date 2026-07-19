class_name Inventory
extends Resource

signal item_equipped(item: ItemData)
signal bag_changed

@export var head: HeadData
@export var chest: ChestData
@export var left_hand: WeaponData
@export var right_hand: WeaponData
@export var legs: LegsData
@export var trinket: TrinketData
@export var drape: DrapeData
@export var gloves: GlovesData
@export var neck: NeckData

@export var bag: Array[ItemData] = []

func equip(item: ItemData) -> void:
	bag.erase(item)
	var previous: ItemData = null
	match item.slot():
		"head":
			previous = head
			head = item as HeadData
		"chest":
			previous = chest
			chest = item as ChestData
		"legs":
			previous = legs
			legs = item as LegsData
		"trinket":
			previous = trinket
			trinket = item as TrinketData
		"drape":
			previous = drape
			drape = item as DrapeData
		"gloves":
			previous = gloves
			gloves = item as GlovesData
		"neck":
			previous = neck
			neck = item as NeckData
		"hand":
			if not left_hand:
				left_hand = item as WeaponData
			elif not right_hand:
				right_hand = item as WeaponData
			else:
				previous = left_hand
				left_hand = item as WeaponData
		_:
			push_warning("Inventory.equip: unknown slot '%s'" % item.slot())
			return
	if previous != null:
		bag.append(previous)
	item_equipped.emit(item)
	bag_changed.emit()

func all_equipped() -> Array[ItemData]:
	var items: Array[ItemData] = []
	for item: ItemData in [head, chest, left_hand, right_hand, legs, trinket, drape, gloves, neck]:
		if item:
			items.append(item)
	return items
