class_name EnemyData
extends GameElement

static func static_type() -> String:
	return "Enemy"

func get_type() -> String:
	return static_type()

var name: String
var strength: int
var sprite_path: String
