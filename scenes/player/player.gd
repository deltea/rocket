class_name Player extends RigidBody2D

@export var thrust_speed = 400.0
@export var turn_speed = 3000.0
@export var rocket_pieces_scene: PackedScene
@export var spawn_y_amount = 18.0
@export var small_rocket_texture: Texture2D

@onready var thrust_particles: CPUParticles2D = $ThrustParticles
@onready var sprite: Sprite2D = $Sprite
@onready var collider: CollisionPolygon2D = $CollisionPolygon
@onready var landing_area: Area2D = $LandingArea

var can_move = false
var torque = 0.0
var spawn_pos: Vector2
var is_on_pad = false
var rocket_texture: Texture2D
var original_particle_pos: Vector2
var original_landing_area_pos: Vector2
var is_small = false

func _enter_tree() -> void:
	RoomManager.current_room.player = self

func _ready() -> void:
	spawn_pos = position
	rocket_texture = sprite.texture

	original_particle_pos = thrust_particles.position
	original_landing_area_pos = landing_area.position

	spawn()

func _physics_process(delta: float) -> void:
	if !can_move: return

	if !is_on_pad:
		torque = rotate_toward(torque, get_angle_to(get_global_mouse_position()) + PI/2, turn_speed * delta)
		apply_torque(torque * turn_speed)

	var thrust_input = Input.is_action_pressed("left_mouse")
	thrust_particles.emitting = thrust_input
	if thrust_input:
		apply_force(Vector2.from_angle(rotation - PI / 2) * thrust_speed)

	if Input.is_action_just_pressed("r"):
		die()

func go_into_portal(portal: Portal):
	can_move = false
	thrust_particles.emitting = false
	collider.set_deferred("disabled", true)

	var tweener = get_tree().create_tween().set_parallel(true)
	tweener.tween_property(sprite, "scale", Vector2.ZERO, 1)
	tweener.tween_property(self, "global_position", portal.position, 1)
	tweener.tween_property(self, "global_rotation_degrees", global_rotation_degrees + 360, 1)

func die():
	var rocket_pieces = rocket_pieces_scene.instantiate() as Node2D
	rocket_pieces.global_position = global_position
	rocket_pieces.rotation = rotation

	if is_small:
		for child in rocket_pieces.get_children():
			child.get_node("Sprite").scale = Vector2(0.5, 0.5)
			child.get_node("CollisionPolygon").scale = Vector2(0.5, 0.5)

	RoomManager.current_room.call_deferred("add_child", rocket_pieces)

	RoomManager.current_room.camera.shake(0.1, 2.0)
	RoomManager.current_room.reset_dust()

	spawn()


func spawn():
	gravity_scale = 1
	linear_velocity = Vector2.ZERO
	angular_velocity = 0
	rotation = 0
	thrust_particles.emitting = false
	set_smallness(false)

	var tween = get_tree().create_tween()
	can_move = false
	collider.set_deferred("disabled", true)
	set_deferred("freeze", true)
	tween.connect("finished", func():
		can_move = true
		collider.disabled = false
		freeze = false
	)
	position = spawn_pos + Vector2(0, spawn_y_amount)
	tween.tween_property(self, "position", spawn_pos, 1.0)

func antigravity():
	gravity_scale *= -1

func set_smallness(value: bool):
	is_small = value
	spawn_y_amount = 0.0 if value else 18.0
	collider.scale = Vector2(0.5, 0.5) if value else Vector2.ONE
	landing_area.scale = Vector2(0.5, 2.0) if value else Vector2.ONE
	sprite.texture = small_rocket_texture if value else rocket_texture
	landing_area.position.y = original_landing_area_pos.y / 2 if value else original_landing_area_pos.y
	thrust_particles.position.y = original_particle_pos.y / 2 if value else original_particle_pos.y
	thrust_particles.amount = 6 if value else 12
	thrust_particles.scale_amount_min = 0.15 if value else 0.3
	thrust_particles.scale_amount_max = 0.2 if value else 0.4
	thrust_particles.lifetime = 0.25 if value else 0.5

func _on_body_entered(body: Node):
	if !can_move: return

	if body is Spikeball or body is TileMap:
		die()

func _on_landing_area_body_entered(body: Node2D):
	if body is Pad:
		is_on_pad = true

func _on_landing_area_body_exited(body: Node2D):
	if body is Pad:
		is_on_pad = false
