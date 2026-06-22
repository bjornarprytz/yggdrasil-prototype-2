class_name EventData
extends GameElement

static func static_type() -> String:
	return "Event"

func get_type() -> String:
	return static_type()

@export var intro_text: String
@export var options: Array[String] = []

@export var background: Texture2D
