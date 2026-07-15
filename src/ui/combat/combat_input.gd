class_name CombatInput
extends Node

var target: CombatPlayer

func _process(_delta: float) -> void:
	if not is_instance_valid(target):
		return
	target.move(Input.get_axis("combat_move_left", "combat_move_right"))
	if Input.is_action_just_pressed("combat_jump"):
		target.jump()
	if Input.is_action_just_pressed("combat_dodge"):
		target.dodge()
	if Input.is_action_just_pressed("combat_light_attack"):
		target.light_attack()
	if Input.is_action_just_pressed("combat_heavy_attack"):
		target.heavy_attack()
	if Input.is_action_just_pressed("combat_ranged"):
		target.ranged_attack()
	if Input.is_action_just_pressed("combat_special"):
		target.special()
