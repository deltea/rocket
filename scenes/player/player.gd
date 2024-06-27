class_name Player extends CharacterBody2D

@export var gravity = 200.0
@export var thrust_speed = 450.0
@export var turn_speed = 180.0
@export var velocity_clamp = Vector2(150.0, 150.0)

@onready var thrust_particles: GPUParticles2D = $ThrustParticles

var can_move = true

func _enter_tree() -> void:
	RoomManager.current_room.player = self

func _physics_process(delta: float) -> void:
	if !can_move: return

	var x_input := Input.get_axis("left", "right")
	rotation_degrees += x_input * turn_speed * delta

	var thrust_input = Input.is_action_pressed("thrust")
	thrust_particles.emitting = thrust_input
	if thrust_input:
		velocity += Vector2.from_angle(rotation - PI / 2) * thrust_speed * delta
	else:
		velocity.y += gravity * delta

	velocity = velocity.clamp(Vector2(-velocity_clamp), Vector2(velocity_clamp))
	move_and_slide()

func go_into_portal(portal: Portal):
	can_move = false
	velocity = Vector2.ZERO
	thrust_particles.emitting = false
	var tweener = get_tree().create_tween().set_parallel(true)
	tweener.tween_property(self, "scale", Vector2.ZERO, 1)
	tweener.tween_property(self, "global_position", portal.position, 1)
	tweener.tween_property(self, "global_rotation_degrees", global_rotation_degrees + 360, 1)
