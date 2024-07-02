class_name Grid extends Node2D

@export var gap = 20.0
@export var col_amount = 3

func _ready() -> void:
	update_grid()

func update_grid() -> void:
	for i in range(get_child_count()):
		var child = get_child(i)
		var row = i / col_amount
		var x = i % col_amount * gap
		var y = row * gap
		child.global_position = global_position + Vector2(x, y)
