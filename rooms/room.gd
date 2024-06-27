class_name Room extends Node2D

@export var palette: Palette

var camera: Camera
var player: Player

func _enter_tree() -> void:
	RoomManager.current_room = self
