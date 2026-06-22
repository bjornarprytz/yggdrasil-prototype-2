class_name Enemy
extends Node2D

@onready var sprite: Sprite2D = %Sprite
@onready var strength: RichTextLabel = %Strength

@export var data: EnemyData

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(data != null)
	sprite.texture = data.sprite
	strength.text = str(data.strength)
