class_name Dust extends Collectable

enum DUST_TYPE { BASIC, ANTIGRAVITY, SMALL }

@export var dust_type: DUST_TYPE = DUST_TYPE.BASIC

@export var antigravity_texture: Texture2D
@export var small_texture: Texture2D

func _ready() -> void:
	super._ready()

	match dust_type:
		DUST_TYPE.BASIC:
			pass
		DUST_TYPE.ANTIGRAVITY:
			sprite.texture = antigravity_texture
		DUST_TYPE.SMALL:
			sprite.texture = small_texture

func _on_collect():
	RoomManager.current_room.collected_dust()
	print("Collected dust")
	match dust_type:
		DUST_TYPE.BASIC:
			pass
		DUST_TYPE.ANTIGRAVITY:
			RoomManager.current_room.player.antigravity()
		DUST_TYPE.SMALL:
			RoomManager.current_room.player.set_smallness(true)
