class_name ItemData
extends GameElement

@export var display_name: String = ""
@export var description: String = ""
@export var icon: Texture2D

static func static_type() -> String:
	return "Item"

func get_type() -> String:
	return static_type()

func slot() -> String:
	return ""

func label() -> String:
	return display_name if display_name != "" else id.replace("_", " ").capitalize()

func tooltip_text() -> String:
	var lines: Array[String] = [label()]
	if slot() != "":
		lines.append("[%s]" % slot())
	if description != "":
		lines.append(description)
	return "\n".join(lines)
