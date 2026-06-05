@abstract
class_name GameElement
extends Resource

@abstract func get_type() -> String

@export var id: String
@export var metadata: Dictionary[String, String] = {}
@export var tags: Array[String] = []
