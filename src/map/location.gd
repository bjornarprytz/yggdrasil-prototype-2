class_name Location
extends Node2D

@export var encounter: EncounterData

@onready var left_anchor: Node2D = %LeftAnchor
@onready var right_anchor: Node2D = %RightAnchor
@onready var button: Button = %Button
@onready var type: RichTextLabel = %Type

var id: int

var is_current: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(encounter != null)
	type.text = encounter.type_str
	button.self_modulate = encounter.type_color

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if (is_current):
		button.position.y = pingpong(Time.get_ticks_msec() / 100.0, 10)
	else:
		button.position.y = 0.0

func _on_button_pressed() -> void:
	print("Entering %s (%d)" % [str(encounter.type_str), id])
