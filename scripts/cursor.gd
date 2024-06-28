class_name Cursor extends TextureRect

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN

func _process(_delta: float) -> void:
	position = get_global_mouse_position() - size	/ 2
