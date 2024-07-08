class_name Player extends RigidBody2D

@export var thrust_speed = 400.0
@export var turn_speed = 3000.0
@export var rocket_pieces_scene: PackedScene
@export var spawn_y_amount = 18.0

@onready var thrust_particles: GPUParticles2D = $ThrustParticles
@onready var sprite: Sprite2D = $Sprite
@onready var collider: CollisionPolygon2D = $CollisionPolygon

var can_move = false
var torque = 0.0
var spawn_pos: Vector2
var is_on_pad = false

func _enter_tree() -> void:
	RoomManager.current_room.player = self

func _ready() -> void:
	spawn_pos = position

	spawn()

func _physics_process(delta: float) -> void:
	if !can_move: return

	if !is_on_pad:
		torque = rotate_toward(torque, get_angle_to(get_global_mouse_position()) + PI/2, turn_speed * delta)
		apply_torque(torque * turn_speed)

	var thrust_input = Input.is_action_pressed("left_mouse")
	thrust_particles.emitting = thrust_input
	if thrust_input:
		apply_force(Vector2.from_angle(rotation - PI / 2) * thrust_speed)

	if Input.is_action_just_pressed("r"):
		die()

func go_into_portal(portal: Portal):
	can_move = false
	thrust_particles.emitting = false
	collider.set_deferred("disabled", true)

	var tweener = get_tree().create_tween().set_parallel(true)
	tweener.tween_property(sprite, "scale", Vector2.ZERO, 1)
	tweener.tween_property(self, "global_position", portal.position, 1)
	tweener.tween_property(self, "global_rotation_degrees", global_rotation_degrees + 360, 1)

func die():
	var rocket_pieces = rocket_pieces_scene.instantiate()
	rocket_pieces.global_position = global_position
	rocket_pieces.rotation = rotation
	RoomManager.current_room.call_deferred("add_child", rocket_pieces)

	RoomManager.current_room.camera.shake(0.1, 2.0)
	RoomManager.current_room.reset_dust()

	spawn()

func spawn():
	gravity_scale = 1
	linear_velocity = Vector2.ZERO
	angular_velocity = 0
	rotation = 0
	thrust_particles.emitting = false

	var tween = get_tree().create_tween()
	can_move = false
	collider.set_deferred("disabled", true)
	set_deferred("freeze", true)
	tween.connect("finished", func():
		can_move = true
		collider.disabled = false
		freeze = false
	)
	position = spawn_pos + Vector2(0, spawn_y_amount)
	tween.tween_property(self, "position", spawn_pos, 1.0)

func antigravity():
	gravity_scale *= -1

func _on_body_entered(body: Node):
	if !can_move: return

	if body is Spikeball or body is TileMap:
		die()

func _on_landing_area_body_entered(body: Node2D):
	if body is Pad:
		is_on_pad = true

func _on_landing_area_body_exited(body: Node2D):
	if body is Pad:
		is_on_pad = false
