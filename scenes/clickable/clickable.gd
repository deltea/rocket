class_name Clickable extends Area2D

signal hover
signal hover_out
signal click

@onready var sprite: Sprite2D = $Sprite
@onready var collider: CollisionShape2D = $CollisionShape

var hovered = false
var disabled = false

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("left_mouse") and hovered and !disabled:
		click.emit()

func _on_mouse_entered():
	if disabled: return
	hovered = true
	hover.emit()

func _on_mouse_exited():
	# if disabled: return
	hovered = false
	hover_out.emit()
