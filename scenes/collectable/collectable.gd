class_name Collectable extends Area2D

enum COLLECT_TYPE { DISAPPEAR, FOLLOW }

signal collect

@export var hover_speed = 3.0
@export var hover_magnitude = 2.0
@export var turn_speed = 1.0
@export var collected_turn_speed = 5.0
@export var collect_type: COLLECT_TYPE = COLLECT_TYPE.DISAPPEAR

@onready var sprite: Sprite2D = $Sprite
@onready var collider: CollisionShape2D = $CollisionShape

var collected = false
var original_pos: Vector2
var rotating = true

func _ready() -> void:
	original_pos = positionz

func _process(delta: float) -> void:
	if rotating:
		rotate(delta * turn_speed)

	if collected: return

	position.y = original_pos.y + sin(Clock.time * hover_speed) * hover_magnitude

func set_collected(value: bool):
	collected = value
	if collected: collect.emit()

	collider.set_deferred("disabled", value)

	match collect_type:
		COLLECT_TYPE.DISAPPEAR: disappear(value)
		COLLECT_TYPE.FOLLOW: follow(value)

func follow(value: bool):
	if value:
		RoomManager.current_room.player.add_collectable(self)
	else:
		RoomManager.current_room.player.remove_collectable(self)
		position = original_pos

func disappear(value: bool):
	var tweener = get_tree().create_tween().set_trans(Tween.TRANS_EXPO)

	if value:
		tweener.tween_property(sprite, "scale", Vector2(1.5, 1.5), 0.15)
		tweener.tween_property(sprite, "scale", Vector2.ZERO, 0.4)
	else:
		tweener.tween_property(sprite, "scale", Vector2.ONE, 1.0)

func _on_body_entered(body: Node2D):
	if body is Player:
		set_collected(true)

