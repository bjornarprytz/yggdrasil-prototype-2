class_name EnemyData
extends GameElement

static func static_type() -> String:
	return "Enemy"

func get_type() -> String:
	return static_type()

@export var sprite: Texture2D
@export var strength: int
