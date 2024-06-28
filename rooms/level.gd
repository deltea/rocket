class_name Level extends Room

@onready var portal: Portal = $Portal
@onready var dusts: Node = $Dusts

var dust_left: int

func _ready() -> void:
	dust_left = dusts.get_child_count()

func collected_dust():
	dust_left -= 1
	print("collected a dust, %s dusts left." % dust_left)
	if dust_left <= 0:
		portal.set_activated(true)

func reset_dust():
	dust_left = dusts.get_child_count()
	portal.set_activated(false)

	for dust in dusts.get_children():
		if dust.collected:
			dust.set_collected(false)
