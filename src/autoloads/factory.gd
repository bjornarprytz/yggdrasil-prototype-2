class_name Factory
extends Node2D

# Add factory methods for common scenes here. Access through the Create singleton

var _location_factory = preload("res://map/location.tscn")
var _connection_factory = preload("res://map/connection.tscn")
var _enemy_factory = preload("res://encounter/enemy.tscn")

func location(id: int) -> Location:
	var f = _location_factory.instantiate() as Location
	f.id = id
	
	return f

func connection(a: Location, b: Location) -> Connection:
	var c = _connection_factory.instantiate() as Connection
	c.a = a
	c.b = b
	
	return c

func enemy(enemy_data: EnemyData) -> Enemy:
	var e = _enemy_factory.instantiate() as Enemy
	e.data = enemy_data
	return e
