class_name EncounterData
extends Resource

enum Type {
	Start,
	Combat,
	Elite,
	Event,
	Shop,
	Boss
}
var type : Type
var properties: Dictionary = {}

func _init(t: Type, props: Dictionary = {}):
	type = t
	properties = props

var type_str: String:
	get:
		return Type.keys()[type]

var type_color: Color:
	get:
		match type:
			Type.Start:
				return Color.WHITE
			Type.Combat:
				return Color.FIREBRICK
			Type.Elite:
				return Color.CRIMSON
			Type.Event:
				return Color.SKY_BLUE
			Type.Shop:
				return Color.DARK_GOLDENROD
			Type.Boss:
				return Color.BLUE_VIOLET
		return Color.DIM_GRAY

func _to_string() -> String:
	return "%s" % [type_str]
