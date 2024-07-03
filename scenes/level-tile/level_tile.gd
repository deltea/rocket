class_name LevelTile extends Clickable

var level_resource: LevelResource

func _on_hover():
	RoomManager.current_room.level_hovered(self)

func _on_click():
	pass # Replace with function body.
