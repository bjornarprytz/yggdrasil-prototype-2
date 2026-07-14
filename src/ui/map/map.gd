class_name Map
extends Node2D

@export var map_data: MapData

@onready var locations: Node = %Locations
@onready var connections: Node = %Connections

signal location_entered(location: Location)

var current_location: Location = null

var conn_weights = [1,1,1,1,1,1,1,1,1,2]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var start_loc = add_location(0,0, EncounterData.Type.Start)
	var prev_layer = [start_loc]
	var next_layer = []
	var layer_index = 0
	for layer_size in map_data.layers:
		var next_conns = []
		for i in range(layer_size):
			var new_loc = add_location(layer_index+1, i, map_data.draw_encounter_type())
			# Pick how many of the prev wheights should connect to this node
			var nConnections = min(conn_weights.pick_random(), prev_layer.size()) 
			prev_layer.shuffle()
			for conn in prev_layer.slice(0,nConnections):
				var new_conn = Create.connection(conn, new_loc)
				connections.add_child(new_conn)
				next_conns.append(new_conn)
			next_layer.append(new_loc)
		for loc in prev_layer:
			if next_conns.any(func (c:Connection): c.has(loc)):
				continue
			connections.add_child(Create.connection(loc, next_layer.pick_random()))
		
		prev_layer.clear()
		prev_layer.append_array(next_layer)
		next_layer = []
		layer_index += 1
	
	var end_loc = add_location(layer_index+1, 0, EncounterData.Type.Boss)
	for conn in prev_layer: # Connect all nodes to the end location
		connections.add_child(Create.connection(conn, end_loc))
	
	change_current(start_loc)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func add_location(layer:int, index: int, type: EncounterData.Type) -> Location:
	var new_loc = Create.location(locations.get_child_count())
	new_loc.encounter = EncounterData.new(type)
	locations.add_child(new_loc)
	new_loc.position.y = 100 + (index * 180)
	new_loc.position.x = 100 + (layer * 200)
	
	new_loc.button.pressed.connect(location_pressed.bind(new_loc))
	
	return new_loc

func change_current(location: Location):
	if (current_location != null):
		current_location.is_current = false
	current_location = location
	current_location.is_current = true

func location_pressed(location: Location):
	change_current(location)
	location_entered.emit(location)
