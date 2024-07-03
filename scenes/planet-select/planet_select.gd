class_name PlanetSelect extends Clickable

@export var area_resource: AreaResource
@export var spin_speed = 0.25

func _ready() -> void:
	sprite.texture = area_resource.texture
	rotation_degrees = randf_range(0, 360)

func _process(delta: float) -> void:
	super._process(delta)
	sprite.rotate(spin_speed * delta)

func _on_click():
	RoomManager.current_room.planet_selected(self)

func _on_hover():
	PaletteFilter.set_color_palette(area_resource.palette)
	RoomManager.current_room.planet_hovered(self)
