class_name Player extends CharacterBody2D

@export var gravity = 100.0

func _physics_process(delta: float) -> void:
	if !is_on_floor():
		velocity.y += gravity * delta

	move_and_slide()
