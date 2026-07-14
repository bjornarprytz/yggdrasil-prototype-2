class_name Connection
extends Line2D

var a: Location
var b: Location

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(a is Location)
	assert(b is Location)
	set_point_position(0, Vector2.ZERO)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position = a.right_anchor.global_position
	
	var b_pos = b.left_anchor.global_position - global_position
	
	set_point_position(1, b_pos)

func has(location: Location):
	return a == location or b == location
