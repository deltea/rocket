class_name RocketPiece extends RigidBody2D

@onready var sprite: Sprite2D = $Sprite
@onready var timer: Timer = $Timer

func _ready() -> void:
	apply_impulse(Vector2.from_angle(randf_range(0, PI*2)) * 50)
	await Clock.wait(randf_range(0.8, 1.5))

	timer.start()
	await Clock.wait(1)
	queue_free()

func _on_timer_timeout() -> void:
	if sprite.self_modulate.a == 0:
		sprite.self_modulate.a = 1
	else:
		sprite.self_modulate.a = 0
