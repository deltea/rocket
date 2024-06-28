class_name Portal extends Area2D

@export var hover_speed = 3.0
@export var hover_magnitude = 2.0

var original_pos: Vector2

func _ready() -> void:
	original_pos = position

func _process(_delta: float) -> void:
	position.y = original_pos.y + (sin(Clock.time * hover_speed) * hover_magnitude)

func _on_body_entered(body: Node2D):
	if body is Player:
		RoomManager.current_room.player.go_into_portal(self)
		await Clock.wait(1.0)
		RoomManager.next_level()
