class_name DatabaseFilter
extends Resource

@export var type: String = ""
@export var include_tags: Array[String] = []
@export var exclude_tags: Array[String] = []

func _init(type_: String = "", include_tags_: Array[String] = [], exclude_tags_: Array[String] = []) -> void:
	type = type_
	include_tags = include_tags_
	exclude_tags = exclude_tags_
