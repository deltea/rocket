class_name RocketPiece extends RigidBody2D

func _ready() -> void:
	apply_impulse(Vector2.from_angle(randf_range(0, PI*2)) * 50)
