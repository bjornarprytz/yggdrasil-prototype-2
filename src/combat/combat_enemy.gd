class_name CombatEnemy
extends CharacterBody2D

const GRAVITY: float = 980.0
const MOVE_SPEED: float = 120.0
const ATTACK_RANGE: float = 80.0
const ATTACK_COOLDOWN: float = 1.4
const ATTACK_STARTUP: float = 0.25
const ATTACK_ACTIVE: float = 0.18
const HIT_STUN_DURATION: float = 0.30

enum State { CHASING, ATTACKING, HIT_STUN, DEAD }

@onready var _sprite: Sprite2D = $Sprite2D
@onready var _hitbox: Area2D = $Hitbox
@onready var _hurtbox: Area2D = $Hurtbox
@onready var _health: Health = $Health

var data: EnemyData = null

var _state: State = State.CHASING
var _state_timer: float = 0.0
var _attack_cooldown: float = 0.0
var _facing: float = -1.0  # faces left (toward player) by default
var _target: CharacterBody2D = null

signal died

func setup(p_data: EnemyData, p_target: CharacterBody2D) -> void:
	data = p_data
	_target = p_target

func _ready() -> void:
	_health.set_max_health(data.strength * 8)
	_health.destroyed.connect(func(): _enter(State.DEAD))

	_hitbox.collision_layer = 8
	_hitbox.collision_mask = 0
	_hitbox.monitoring = false
	_hitbox.set_meta("damage", data.strength)
	_hitbox.set_meta("knockback", Vector2(280.0, -70.0))

	_hurtbox.collision_layer = 16
	_hurtbox.collision_mask = 2   # detect player hitbox
	_hurtbox.monitorable = true
	_hurtbox.area_entered.connect(_on_hit)

	if data.sprite:
		$Sprite2D.texture = data.sprite

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	_state_timer = maxf(_state_timer - delta, 0.0)
	_attack_cooldown = maxf(_attack_cooldown - delta, 0.0)

	match _state:
		State.CHASING:
			_chase(delta)
		State.ATTACKING:
			velocity.x = move_toward(velocity.x, 0.0, 600.0 * delta)
			if _state_timer == 0.0:
				_hitbox.monitoring = false
				_enter(State.CHASING)
		State.HIT_STUN:
			velocity.x = move_toward(velocity.x, 0.0, 700.0 * delta)
			if _state_timer == 0.0:
				_enter(State.CHASING)
		State.DEAD:
			velocity.x = move_toward(velocity.x, 0.0, 300.0 * delta)

	move_and_slide()

func _chase(delta: float) -> void:
	if _target == null:
		return
	var diff := _target.global_position.x - global_position.x
	_facing = signf(diff)
	_sprite.flip_h = _facing > 0.0

	if absf(diff) <= ATTACK_RANGE and _attack_cooldown == 0.0:
		_begin_attack()
		return

	velocity.x = _facing * MOVE_SPEED

func _begin_attack() -> void:
	_enter(State.ATTACKING)
	_state_timer = ATTACK_STARTUP + ATTACK_ACTIVE + 0.15
	_attack_cooldown = ATTACK_COOLDOWN
	_hitbox.set_meta("facing", _facing)
	velocity.x = _facing * 60.0
	get_tree().create_timer(ATTACK_STARTUP).timeout.connect(
		func(): _hitbox.monitoring = true, CONNECT_ONE_SHOT)
	get_tree().create_timer(ATTACK_STARTUP + ATTACK_ACTIVE).timeout.connect(
		func(): _hitbox.monitoring = false, CONNECT_ONE_SHOT)

func _on_hit(hitbox: Area2D) -> void:
	if _state == State.DEAD:
		return
	var dmg: int = hitbox.get_meta("damage", 0)
	var kb: Vector2 = hitbox.get_meta("knockback", Vector2.ZERO)
	var src_facing: float = hitbox.get_meta("facing", 1.0)
	_health.damage(dmg)
	velocity = Vector2(kb.x * src_facing, kb.y)
	if _health.current_health > 0:
		_enter(State.HIT_STUN)
		_state_timer = HIT_STUN_DURATION

func _enter(new_state: State) -> void:
	if new_state == State.DEAD and _state != State.DEAD:
		died.emit()
	_state = new_state
