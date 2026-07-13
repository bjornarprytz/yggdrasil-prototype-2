class_name Player
extends Node2D

var inventory: Inventory = Inventory.new()
var resources: Dictionary[String, int] = {}
@onready var health: Health = %Health

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health.set_max_health(100)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
