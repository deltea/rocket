class_name Clickable extends Area2D

signal hover
signal hover_out
signal click

@onready var sprite: Sprite2D = $Sprite
@onready var collider: CollisionShape2D = $CollisionShape

var hovered = false

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("left_mouse") and hovered:
		click.emit()

func _on_mouse_entered():
	hovered = true
	hover.emit()

func _on_mouse_exited():
	hovered = false
	hover_out.emit()
