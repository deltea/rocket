class_name Dust extends Area2D

@export var hover_speed = 3.0
@export var hover_magnitude = 0.1
@export var turn_speed = 1.0

func _process(delta: float) -> void:
	position.y = position.y + (sin(Clock.time * hover_speed) * hover_magnitude)
	rotate(delta * 2)

func _on_body_entered(body: Node2D):
	if body is Player:
		queue_free()
