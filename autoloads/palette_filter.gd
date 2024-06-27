extends CanvasLayer

@export var default_palette: Palette

var palette: Palette

func _ready() -> void:
	palette = default_palette
	if RoomManager.current_room.palette:
		palette = RoomManager.current_room.palette

	set_filter()

func set_filter():
	$ColorRect.material.set_shader_parameter("new_primary", palette.primary)
	$ColorRect.material.set_shader_parameter("new_accent", palette.accent)
	$ColorRect.material.set_shader_parameter("new_background", palette.background)
	$ColorRect.material.set_shader_parameter("new_midground", palette.midground)
	$ColorRect.material.set_shader_parameter("new_foreground", palette.foreground)
