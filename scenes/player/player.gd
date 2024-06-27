class_name Player extends RigidBody2D

@export var thrust_speed = 450.0
@export var turn_speed = 3000.0
@export var rocket_pieces_scene: PackedScene

@onready var thrust_particles: GPUParticles2D = $ThrustParticles

var can_move = true
var torque = 0.0
var original_pos: Vector2

func _enter_tree() -> void:
	RoomManager.current_room.player = self

func _ready() -> void:
	original_pos = position

func _physics_process(delta: float) -> void:
	if !can_move: return

	torque = rotate_toward(torque, get_angle_to(get_global_mouse_position()) + PI/2, turn_speed * delta)
	apply_torque(torque * turn_speed)

	var thrust_input = Input.is_action_pressed("thrust")
	thrust_particles.emitting = thrust_input
	if thrust_input:
		apply_force(Vector2.from_angle(rotation - PI / 2) * thrust_speed)

func go_into_portal(portal: Portal):
	can_move = false
	thrust_particles.emitting = false
	var tweener = get_tree().create_tween().set_parallel(true)
	tweener.tween_property(self, "scale", Vector2.ZERO, 1)
	tweener.tween_property(self, "global_position", portal.position, 1)
	tweener.tween_property(self, "global_rotation_degrees", global_rotation_degrees + 360, 1)
	await Clock.wait(1.0)
	scale = Vector2.ZERO

func die():
	PhysicsServer2D.body_set_state(
    get_rid(),
    PhysicsServer2D.BODY_STATE_TRANSFORM,
    Transform2D.IDENTITY.translated(original_pos)
	)

	var rocket_pieces = rocket_pieces_scene.instantiate()
	rocket_pieces.global_position = global_position
	rocket_pieces.rotation = rotation
	RoomManager.current_room.call_deferred("add_child", rocket_pieces)

func _on_body_entered(body: Node):
	if body is Spikeball or body is TileMap:
		die()
