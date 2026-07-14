class_name Move
extends Resource

@export var damage: int = 10
@export var knockback: Vector2 = Vector2(300.0, -80.0)
@export var startup_time: float = 0.08   # before hitbox activates
@export var active_time: float = 0.12    # hitbox live window
@export var recovery_time: float = 0.22  # locked after hitbox closes
@export var lunge_speed: float = 0.0     # forward velocity burst on swing
