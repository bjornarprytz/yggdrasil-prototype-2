@abstract
class_name GameElement
extends Resource

@abstract func get_type() -> String

## Must be unique across elements of the same type
@export var id: String
@export var metadata: Dictionary[String, String] = {}
@export var tags: Array[String] = []

func _to_string() -> String:
	return id
