class_name LevelTile extends Clickable

@onready var num_label: Label = $NumLabel

var level_resource: LevelResource
var level_num: int

func _ready() -> void:
	num_label.text = str(level_num)

func _on_hover():
	RoomManager.current_room.level_hovered(self)

func _on_click():
	RoomManager.current_room.level_selected(self)
