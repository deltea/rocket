class_name Spikeball extends StaticBody2D

@export var spin_speed = 5.0

func _process(delta: float) -> void:
	rotate(delta * spin_speed)
