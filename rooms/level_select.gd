class_name LevelSelect extends Room

@export var panel_smoothing = 10.0
@export var planet_selector_smoothing = 15.0
@export var camera_look = 0.15
@export var dotted_line_scene: PackedScene

@onready var panel: Panel = $Canvas/Panel
@onready var planets_parent: Node = $Planets
@onready var planet_selector: Sprite2D = $PlanetSelector

var panel_target_y = 240.0
var planet_selector_target: Vector2

func _ready() -> void:
	camera = $Camera
	planet_selector_target = planets_parent.get_child(0).global_position

	for i in range(planets_parent.get_child_count()):
		if i == planets_parent.get_child_count() - 1: return
		var planet = planets_parent.get_child(i)
		var next_planet = planets_parent.get_child(i + 1)

		var dotted_line = dotted_line_scene.instantiate() as Line2D
		dotted_line.add_point(planet.global_position)
		dotted_line.add_point(next_planet.global_position)
		dotted_line.z_index = -1
		add_child(dotted_line)

func _process(delta: float) -> void:
	camera.global_position = get_global_mouse_position() * camera_look

	panel.position.y = lerp(panel.position.y, panel_target_y, panel_smoothing * delta)
	planet_selector.global_position = lerp(planet_selector.global_position, planet_selector_target, planet_selector_smoothing * delta)

func planet_selected(planet: Planet) -> void:
	panel_target_y = 0.0

func planet_hovered(planet: Planet):
	planet_selector_target = planet.global_position
