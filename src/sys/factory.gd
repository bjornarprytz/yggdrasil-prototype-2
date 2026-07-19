class_name Factory
extends Node2D

# Add factory methods for common scenes here. Access through the Create singleton

var _location_factory = preload("res://ui/map/location.tscn")
var _connection_factory = preload("res://ui/map/connection.tscn")
var _enemy_factory = preload("res://ui/encounter/enemy.tscn")
var _item_card_factory = preload("res://ui/inventory/item_card.tscn")

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

func item_card(item: ItemData) -> ItemCard:
	var c = _item_card_factory.instantiate() as ItemCard
	c.set_item(item)
	return c

func empty_item_card(label: String = "Empty") -> ItemCard:
	var c = _item_card_factory.instantiate() as ItemCard
	c.set_empty(label)
	return c
