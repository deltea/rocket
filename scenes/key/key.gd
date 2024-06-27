class_name Key extends Area2D

@export var hover_speed = 1.0
@export var hover_magnitude = 0.04
@export var turn_speed = 1.0

func _process(delta: float) -> void:
	position.y = position.y + (sin(Clock.time * hover_speed) * hover_magnitude)
	rotate(turn_speed * delta)
