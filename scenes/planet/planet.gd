class_name Planet extends Area2D

@export var area_resource: AreaResource
@export var spin_speed = 0.25

@onready var sprite: Sprite2D = $Sprite

var hovered = false

func _ready() -> void:
	sprite.texture = area_resource.texture
	rotation_degrees = randf_range(0, 360)

func _process(delta: float) -> void:
	sprite.rotate(spin_speed * delta)

	if Input.is_action_just_pressed("left_mouse") and hovered:
		RoomManager.current_room.planet_selected(self)

func _on_mouse_entered():
	PaletteFilter.set_color_palette(area_resource.palette)
	RoomManager.current_room.planet_hovered(self)
	print("Mouse entered ", area_resource.area_name)
	hovered = true

func _on_mouse_exited():
	print("Mouse exited ", area_resource.area_name)
	hovered = false
