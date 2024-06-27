extends Node

var current_room: Room

func change_room(room: String):
	var path = "res://rooms/" + room + ".tscn"
	if !ResourceLoader.exists(path):
		printerr("Room not found: " + path)
		return

	var scene = load(path)
	get_tree().change_scene_to_packed(scene)

func next_level():
	var level_num = get_tree().current_scene.name.erase(0, 5).to_int()
	change_room("levels/level_" + str(level_num + 1))
