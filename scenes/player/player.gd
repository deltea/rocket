class_name Player extends CharacterBody2D

@export var gravity = 250.0
@export var thrust_speed = 400.0
@export var turn_speed = 150.0

func _physics_process(delta: float) -> void:
	if !is_on_floor():
		velocity.y += gravity * delta

	var x_input := Input.get_axis("left", "right")
	rotation_degrees += x_input * turn_speed * delta

	var thrust_input = Input.is_action_pressed("thrust")
	if thrust_input:
		velocity += Vector2.from_angle(rotation - PI / 2) * thrust_speed * delta

	move_and_slide()
