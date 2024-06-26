class_name Key extends Area2D

@export var hover_speed = 3.0
@export var hover_magnitude = 2.0
@export var turn_speed = 1.0

var original_pos: Vector2

func _ready() -> void:
	original_pos = position

func _process(delta: float) -> void:
	position.y = original_pos.y + (sin(Clock.time * hover_speed) * hover_magnitude)
	rotate(turn_speed * delta)
