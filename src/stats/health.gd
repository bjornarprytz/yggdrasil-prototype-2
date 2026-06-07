class_name Health
extends Node2D

signal damaged(new_health: int, damage: int)
signal healed(new_health: int, heal: int)
signal changed(new_health: int, change: int)

signal destroyed

var max_health: int
var current_health: int

func set_max_health(new_max: int):
	var change = new_max - max_health
	max_health = new_max
	
	if (change > 0):
		heal(change)
	elif (current_health > max_health):
		set_health(max_health)

func set_health(new_health: int):
	var change = new_health - current_health
	current_health = new_health
	changed.emit(current_health, change)

func damage(amount: int):
	if (amount == 0 || current_health <= 0):
		return
	assert(amount > 0)
	
	var prev_health = current_health
	current_health = max(current_health - amount, 0)
	
	var actual_damage = prev_health - current_health
	damaged.emit(current_health, actual_damage)
	changed.emit(current_health, -actual_damage)
	if (current_health <= 0):
		destroyed.emit()

func heal(amount: int):
	if (amount == 0 || current_health >= max_health):
		return
	assert(amount > 0)
	
	var prev_health = current_health
	current_health = min(current_health + amount, max_health)
	
	var actual_heal = current_health - prev_health
	healed.emit(current_health, actual_heal)
	changed.emit(current_health, actual_heal)
