class_name LevelTile extends Area2D

var hovered = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("left_mouse") and hovered:
		pass

func _on_mouse_entered():
	RoomManager.current_room.level_hovered(self)
	hovered = true

func _on_mouse_exited():
	hovered = false
