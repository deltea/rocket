class_name Player extends CharacterBody2D

@export var gravity = 200.0
@export var thrust_speed = 450.0
@export var turn_speed = 180.0
@export var velocity_clamp = Vector2(150.0, 150.0)

@onready var thrust_particles: GPUParticles2D = $ThrustParticles

func _physics_process(delta: float) -> void:
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
