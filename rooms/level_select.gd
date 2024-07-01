class_name LevelSelect extends Room

func _ready() -> void:
	camera = $Camera

func _process(delta: float) -> void:
	camera.global_position = get_global_mouse_position() * 0.05
