class_name Portal extends Area2D

@export var hover_speed = 1.0
@export var hover_magnitude = 0.04

func _process(delta: float) -> void:
	position.y = position.y + (sin(Clock.time * hover_speed) * hover_magnitude)

func _on_body_entered(body: Node2D):
	if body is Player:
		RoomManager.current_room.player.go_into_portal(self)
		await Clock.wait(1.0)
		RoomManager.next_level()
