class_name Cursor extends Sprite2D

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN

func _process(delta: float) -> void:
	position = get_global_mouse_position()
