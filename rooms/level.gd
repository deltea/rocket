class_name Level extends Room

@onready var portal: Portal = $Portal
@onready var collectables: Node = $Collectables
@onready var dusts: Node = $Collectables/Dusts

var dust_left: int

func _ready() -> void:
	dust_left = dusts.get_child_count()
	print(dust_left)

func collected_dust():
	dust_left -= 1
	print("collected a dust, %s dusts left." % dust_left)
	if dust_left <= 0:
		portal.set_activated(true)

func reset_collectables():
	dust_left = dusts.get_child_count()
	portal.set_activated(false)

	for group in collectables.get_children():
		for collectable in group.get_children():
			collectable.visible = true
			collectable.set_collected(false)
