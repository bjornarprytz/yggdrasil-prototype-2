class_name CombatArena
extends Node2D

const PLAYER_START_X: float = 220.0
const ENEMY_START_X: float = 860.0
const FLOOR_Y: float = 480.0

var _player_node: CombatPlayer
var _enemy_node: CombatEnemy
var _enemy_data: EnemyData

signal completed(outcomes: Array[Outcome])

func _ready() -> void:
	_register_inputs()

func setup(enemy_data: EnemyData, player: Player) -> void:
	_enemy_data = enemy_data

	var weapon := _find_weapon(player.inventory)

	_player_node = preload("res://combat/combat_player.tscn").instantiate()
	_player_node.position = Vector2(PLAYER_START_X, FLOOR_Y - 50.0)
	_player_node.setup(player.health, weapon)
	_player_node.died.connect(_on_player_died)
	add_child(_player_node)

	_enemy_node = preload("res://combat/combat_enemy.tscn").instantiate()
	_enemy_node.position = Vector2(ENEMY_START_X, FLOOR_Y - 54.0)
	_enemy_node.setup(enemy_data, _player_node)
	_enemy_node.died.connect(_on_enemy_died)
	add_child(_enemy_node)

func _find_weapon(inventory: Inventory) -> WeaponData:
	if inventory.left_hand:
		return inventory.left_hand
	if inventory.right_hand:
		return inventory.right_hand
	return _default_weapon()

func _default_weapon() -> WeaponData:
	var light := Move.new()
	light.damage = 8
	light.knockback = Vector2(280.0, -60.0)
	light.startup_time = 0.07
	light.active_time = 0.11
	light.recovery_time = 0.18
	light.lunge_speed = 120.0

	var heavy := Move.new()
	heavy.damage = 18
	heavy.knockback = Vector2(400.0, -120.0)
	heavy.startup_time = 0.18
	heavy.active_time = 0.14
	heavy.recovery_time = 0.35
	heavy.lunge_speed = 60.0

	var w := WeaponData.new()
	w.light_attack = light
	w.heavy_attack = heavy
	return w

func _on_enemy_died() -> void:
	var gold := ResourceChange.new()
	gold.resource_type = "gold"
	gold.amount_min = _enemy_data.strength * 4
	gold.amount_max = _enemy_data.strength * 8
	completed.emit([gold] as Array[Outcome])

func _on_player_died() -> void:
	completed.emit([] as Array[Outcome])

func _register_inputs() -> void:
	var defs: Dictionary = {
		"combat_move_left":     [_key(KEY_A), _btn(JOY_BUTTON_DPAD_LEFT),  _axis(JOY_AXIS_LEFT_X, -1.0)],
		"combat_move_right":    [_key(KEY_D), _btn(JOY_BUTTON_DPAD_RIGHT), _axis(JOY_AXIS_LEFT_X,  1.0)],
		"combat_light_attack":  [_key(KEY_J), _btn(JOY_BUTTON_X)],
		"combat_heavy_attack":  [_key(KEY_K), _btn(JOY_BUTTON_Y)],
		"combat_dodge":         [_key(KEY_SPACE), _btn(JOY_BUTTON_B)],
	}
	for action in defs:
		if InputMap.has_action(action):
			continue
		InputMap.add_action(action, 0.2)
		for event in defs[action]:
			InputMap.action_add_event(action, event)

static func _key(code: Key) -> InputEventKey:
	var e := InputEventKey.new()
	e.physical_keycode = code
	return e

static func _btn(button: JoyButton) -> InputEventJoypadButton:
	var e := InputEventJoypadButton.new()
	e.button_index = button
	return e

static func _axis(axis: JoyAxis, value: float) -> InputEventJoypadMotion:
	var e := InputEventJoypadMotion.new()
	e.axis = axis
	e.axis_value = value
	return e
