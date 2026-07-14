class_name CombatPlayer
extends CharacterBody2D

const GRAVITY: float = 980.0
const MOVE_SPEED: float = 260.0
const DODGE_SPEED: float = 520.0
const DODGE_DURATION: float = 0.28
const DODGE_INVULN_END: float = 0.22  # invincibility ends slightly before dodge does
const HIT_STUN_DURATION: float = 0.38

enum State { IDLE, ATTACKING, DODGING, HIT_STUN, DEAD }

@onready var _sprite: Sprite2D = $Sprite2D
@onready var _hitbox: Area2D = $Hitbox
@onready var _hurtbox: Area2D = $Hurtbox

var health: Health = null
var weapon: WeaponData = null

var _state: State = State.IDLE
var _state_timer: float = 0.0
var _facing: float = 1.0
var _invincible: bool = false

signal died

func setup(p_health: Health, p_weapon: WeaponData) -> void:
	health = p_health
	weapon = p_weapon
	health.destroyed.connect(func(): _enter(State.DEAD))

func _ready() -> void:
	# Collision layers: player hitbox = 2, player hurtbox = 4
	# Enemy hitbox = 8, enemy hurtbox = 16
	_hitbox.collision_layer = 2
	_hitbox.collision_mask = 0
	_hitbox.monitoring = false
	_hurtbox.collision_layer = 4
	_hurtbox.collision_mask = 8   # detect enemy hitbox
	_hurtbox.monitorable = true
	_hurtbox.area_entered.connect(_on_hit)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	_state_timer = maxf(_state_timer - delta, 0.0)

	match _state:
		State.IDLE:
			_handle_movement()
			_handle_actions()
		State.ATTACKING:
			velocity.x = move_toward(velocity.x, 0.0, 800.0 * delta)
			if _state_timer == 0.0:
				_hitbox.monitoring = false
				_enter(State.IDLE)
		State.DODGING:
			velocity.x = _facing * DODGE_SPEED
			if _state_timer == 0.0:
				_invincible = false
				_enter(State.IDLE)
		State.HIT_STUN:
			velocity.x = move_toward(velocity.x, 0.0, 700.0 * delta)
			if _state_timer == 0.0:
				_enter(State.IDLE)
		State.DEAD:
			velocity.x = move_toward(velocity.x, 0.0, 400.0 * delta)

	move_and_slide()

func _handle_movement() -> void:
	var dir := Input.get_axis("combat_move_left", "combat_move_right")
	velocity.x = dir * MOVE_SPEED
	if dir != 0.0:
		_facing = signf(dir)
		_sprite.flip_h = _facing < 0.0

func _handle_actions() -> void:
	if Input.is_action_just_pressed("combat_dodge"):
		_invincible = true
		_enter(State.DODGING)
		_state_timer = DODGE_DURATION
		get_tree().create_timer(DODGE_INVULN_END).timeout.connect(
			func(): _invincible = false, CONNECT_ONE_SHOT)
		return
	if weapon == null:
		return
	if Input.is_action_just_pressed("combat_heavy_attack") and weapon.heavy_attack:
		_begin_attack(weapon.heavy_attack)
	elif Input.is_action_just_pressed("combat_light_attack") and weapon.light_attack:
		_begin_attack(weapon.light_attack)

func _begin_attack(move: Move) -> void:
	_enter(State.ATTACKING)
	_state_timer = move.startup_time + move.active_time + move.recovery_time
	velocity.x = _facing * move.lunge_speed
	_hitbox.monitoring = false
	_hitbox.set_meta("damage", move.damage)
	_hitbox.set_meta("knockback", move.knockback)
	_hitbox.set_meta("facing", _facing)
	# Activate hitbox after startup, deactivate after active window
	get_tree().create_timer(move.startup_time).timeout.connect(
		func(): _hitbox.monitoring = true, CONNECT_ONE_SHOT)
	get_tree().create_timer(move.startup_time + move.active_time).timeout.connect(
		func(): _hitbox.monitoring = false, CONNECT_ONE_SHOT)

func _on_hit(hitbox: Area2D) -> void:
	if _invincible or _state == State.DEAD:
		return
	var dmg: int = hitbox.get_meta("damage", 0)
	var kb: Vector2 = hitbox.get_meta("knockback", Vector2.ZERO)
	var src_facing: float = hitbox.get_meta("facing", 1.0)
	health.damage(dmg)
	velocity = Vector2(kb.x * src_facing, kb.y)
	if health.current_health > 0:
		_enter(State.HIT_STUN)
		_state_timer = HIT_STUN_DURATION

func _enter(new_state: State) -> void:
	if new_state == State.DEAD and _state != State.DEAD:
		died.emit()
	_state = new_state
