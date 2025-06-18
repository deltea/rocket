class_name Door extends StaticBody2D

@export var animation_duration = 1.0

@onready var top_half: Sprite2D = $TopHalf
@onready var bottom_half: Sprite2D = $BottomHalf
@onready var collider: CollisionShape2D = $CollisionShape

var open = false

func set_doors(value: bool) -> void:
	open = value

	var tween = get_tree().create_tween().set_parallel()
	tween.tween_property(top_half, "position", top_half.position + Vector2(0, -24 if open else 24), animation_duration)
	tween.tween_property(bottom_half, "position", bottom_half.position + Vector2(0, 24 if open else -24), animation_duration)

	collider.set_deferred("disabled", open)

