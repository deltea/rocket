class_name Grid extends Node2D

@export var gap = 20.0
@export var col_amount = 3

func _ready() -> void:
	update_grid()

func update_grid() -> void:
	var row_amount = ceil(get_child_count() / float(col_amount))
	for i in range(get_child_count()):
		var child = get_child(i)
		var row = i / col_amount
		var x = i % col_amount * gap - (col_amount - 1) * gap / 2
		var y = row * gap - (row_amount - 1) * gap / 2
		child.position = Vector2(x, y)
