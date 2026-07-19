class_name Connection
extends Node2D

@export var width: float = 5.0
@export var color: Color = Color(0.15532574, 0.15532571, 0.15532571, 1)
@export var dash_length: float = 10.0

var a: Location
var b: Location

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(a is Location)
	assert(b is Location)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	queue_redraw()


func _draw() -> void:
	var from = to_local(a.global_position)
	var to = to_local(b.global_position)
	draw_dashed_line(from, to, color, width, dash_length, true, true)


func has(location: Location):
	return a == location or b == location
