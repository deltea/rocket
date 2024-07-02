class_name LevelSelect extends Room

@export var planet_selector_smoothing = 15.0
@export var dotted_line_scene: PackedScene
@export var parallax_effect = 0.05
@export var star_texture: Texture2D
@export var big_star_texture: Texture2D
@export var big_star_probability = 0.05
@export var star_num = 100
@export var camera_smoothing = 10.0

@onready var parallax_layers: Node2D = $ParallaxLayers
@onready var planets_parent: Node = $ParallaxLayers/Layer1/Planets
@onready var planet_selector: Sprite2D = $ParallaxLayers/Layer1/PlanetSelector
@onready var galaxy: TileMap = $ParallaxLayers/Layer3/Galaxy
@onready var star_parent: Node2D = $ParallaxLayers/Layer2/Stars

var planet_selector_target: Vector2
var camera_target_pos = Vector2.ZERO

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
		$ParallaxLayers/Layer1.add_child(dotted_line)

func _process(delta: float) -> void:
	camera.global_position = lerp(camera.global_position, camera_target_pos, camera_smoothing * delta)

	for i in range(parallax_layers.get_child_count()):
		var layer = parallax_layers.get_child(i)
		layer.global_position = (get_global_mouse_position() - camera.position) * parallax_effect * (i + 1)

	planet_selector.position = lerp(planet_selector.position, planet_selector_target, planet_selector_smoothing * delta)

func planet_selected(planet: Planet) -> void:
	camera_target_pos = Vector2(0, 240)

func planet_hovered(planet: Planet):
	planet_selector_target = planet.position
