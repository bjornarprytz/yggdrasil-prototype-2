class_name ResourceChange
extends GameElement

static func static_type():
	return "resource"

func get_type():
	return static_type()


var resource_type: String
var change: int

func _init(type: String, amount: int):
	resource_type = type
	change = amount
	id = "%s:%d" % [type, amount]
