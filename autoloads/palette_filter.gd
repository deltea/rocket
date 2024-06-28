extends CanvasLayer

@export var default_palette: Texture2D

var palette: Texture2D

func _ready() -> void:
	palette = default_palette
	if RoomManager.current_room.palette:
		palette = RoomManager.current_room.palette

	$ColorRect.material.set_shader_parameter("palette_out", palette)
