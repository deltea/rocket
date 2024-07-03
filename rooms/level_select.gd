class_name LevelSelect extends Room

@export var selector_smoothing = 15.0
@export var dotted_line_scene: PackedScene
@export var parallax_effect = 0.025
@export var star_texture: Texture2D
@export var big_star_texture: Texture2D
@export var big_star_probability = 0.05
@export var star_num = 100
@export var camera_smoothing = 10.0
@export var level_tile_scene: PackedScene

@onready var parallax_layers: Node2D = $ParallaxLayers
@onready var planets_parent: Node = $ParallaxLayers/Layer3/Planets
@onready var planet_selector: Sprite2D = $ParallaxLayers/Layer3/PlanetSelector
@onready var level_selector: Sprite2D = $ParallaxLayers/Layer3/LevelSelector
@onready var galaxy: TileMap = $ParallaxLayers/Layer1/Galaxy
@onready var star_parent: Node2D = $ParallaxLayers/Layer2/Stars
@onready var levels_grid: Grid = $ParallaxLayers/Layer3/LevelsGrid
@onready var planet_label: RichTextLabel = $ParallaxLayers/Layer2/PlanetLabel

var planet_selector_target: Vector2
var level_selector_target: Vector2
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
		$ParallaxLayers/Layer3.add_child(dotted_line)

func _process(delta: float) -> void:
	camera.global_position = lerp(camera.global_position, camera_target_pos, camera_smoothing * delta)

	for i in range(parallax_layers.get_child_count()):
		var layer = parallax_layers.get_child(i)
		layer.global_position = (get_global_mouse_position() - camera.position) * parallax_effect * (i + 1)

	planet_selector.position = lerp(planet_selector.position, planet_selector_target, selector_smoothing * delta)
	level_selector.position = lerp(level_selector.position, level_selector_target, selector_smoothing * delta)

func level_hovered(level_tile: LevelTile):
	level_selector_target = level_tile.position

func level_selected(level_tile: LevelTile):
	pass

func planet_hovered(planet: PlanetSelect):
	planet_selector_target = planet.position

func planet_selected(planet: PlanetSelect) -> void:
	camera_target_pos = Vector2(0, 240)
	planet_label.text = "\n[center][wave freq=3.0 connected=0 amp=75]%s[/wave]" % planet.area_resource.area_name.to_upper()

	for child in levels_grid.get_children():
		child.queue_free()

	for level in planet.area_resource.levels:
		var level_tile = level_tile_scene.instantiate() as LevelTile
		level_tile.level_resource = level
		levels_grid.add_child(level_tile)
	levels_grid.update_grid()
