class_name LevelSelect extends Room

@export var planet_selector_smoothing = 15.0
@export var camera_look = 0.15
@export var dotted_line_scene: PackedScene
@export var parallax_effect = 0.05
@export var star_texture: Texture2D
@export var big_star_texture: Texture2D
@export var big_star_probability = 0.05
@export var star_num = 100
@export var camera_smoothing = 10.0

@onready var planets_parent: Node = $Planets
@onready var planet_selector: Sprite2D = $PlanetSelector
@onready var galaxy: TileMap = $Galaxy
@onready var star_parent: Node2D = $Stars

var planet_selector_target: Vector2
var camera_target_pos = Vector2.ZERO
var camera_pos = Vector2.ZERO

func _ready() -> void:
	camera = $Camera
	planet_selector_target = planets_parent.get_child(0).global_position

	for i in range(star_num):
		var star = Sprite2D.new()
		star.texture = big_star_texture if randf() < big_star_probability else star_texture
		star.global_position = Vector2(randf_range(-160, 160), randf_range(-120, 120 + 320))
		star_parent.add_child(star)

	for i in range(planets_parent.get_child_count()):
		if i == planets_parent.get_child_count() - 1: continue
		var planet = planets_parent.get_child(i)
		var next_planet = planets_parent.get_child(i + 1)

		var dotted_line = dotted_line_scene.instantiate() as Line2D
		dotted_line.add_point(planet.global_position)
		dotted_line.add_point(next_planet.global_position)
		dotted_line.z_index = -1
		add_child(dotted_line)

func _process(delta: float) -> void:
	camera_pos = lerp(camera_pos, camera_target_pos, camera_smoothing * delta)
	camera.global_position = camera_pos + get_global_mouse_position() * camera_look

	galaxy.global_position = get_global_mouse_position() * parallax_effect
	star_parent.global_position = get_global_mouse_position() * parallax_effect * 2

	planet_selector.global_position = lerp(planet_selector.global_position, planet_selector_target, planet_selector_smoothing * delta)

func planet_selected(planet: Planet) -> void:
	camera_target_pos = Vector2(0, 240)

func planet_hovered(planet: Planet):
	planet_selector_target = planet.global_position
