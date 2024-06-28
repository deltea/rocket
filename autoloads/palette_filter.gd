extends CanvasLayer

@export var default_palette: Texture2D

var palette: Texture2D

func _ready() -> void:
	set_color_palette()

func set_color_palette():
	palette = default_palette
	if RoomManager.current_room.palette:
		palette = RoomManager.current_room.palette

	print("color palette changed to " + palette.resource_path)

	$ColorRect.material.set_shader_parameter("palette_out", palette)
