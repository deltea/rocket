class_name Dust extends Area2D

@export var hover_speed = 3.0
@export var hover_magnitude = 2.0
@export var turn_speed = 1.0

@onready var sprite: Sprite2D = $Sprite
@onready var collider: CollisionShape2D = $CollisionShape

var original_pos: Vector2
var collected = false

func _ready() -> void:
	original_pos = position

func _process(delta: float) -> void:
	position.y = original_pos.y + (sin(Clock.time * hover_speed) * hover_magnitude)
	rotate(delta * 2)

func set_collected(value: bool):
	collected = value
	sprite.visible = !value
	collider.set_deferred("disabled", value)

func _on_body_entered(body: Node2D):
	if body is Player:
		RoomManager.current_room.collected_dust()
		set_collected(true)
