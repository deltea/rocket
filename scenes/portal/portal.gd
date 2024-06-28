class_name Portal extends Area2D

@export var hover_speed = 3.0
@export var hover_magnitude = 2.0

@onready var sprite: Sprite2D = $Sprite
@onready var particles: GPUParticles2D = $Particles

var original_pos: Vector2
var activated = false

func _ready() -> void:
	original_pos = position

func _process(_delta: float) -> void:
	position.y = original_pos.y + (sin(Clock.time * hover_speed) * hover_magnitude)
	if activated:
		sprite.scale = Vector2.ONE + Vector2.ONE * (sin(Clock.time * 5.0) * 0.2)

func set_activated(value: bool):
	activated = value

	var color = Color.BLUE if value else Color.WHITE
	sprite.self_modulate = color
	particles.self_modulate = color

func _on_body_entered(body: Node2D):
	if body is Player && activated:
		RoomManager.current_room.player.go_into_portal(self)
		await Clock.wait(1.0)
		RoomManager.next_level()
