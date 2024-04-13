extends StaticBody2D

class_name Unit

@export var move_speed : float
@export var rotate_speed : float
@export var avoidance_fac : float
@onready var overlap : Area2D = $OverlapArea

var velocity : Vector2
var move_dir : Vector2
var noise_coord : float
var noise_gen : FastNoiseLite
var prev_noise : float

func _ready():
	init_movement()

func init_movement():
	noise_gen = FastNoiseLite.new()
	noise_gen.set_frequency(0.25)
	var noise_seed = randi()
	noise_gen.set_seed(noise_seed)
	move_dir = Vector2.from_angle(randf() * 6.2) # scale random float by radians in 360 degrees

func _physics_process(delta):
	velocity = move_dir * move_speed * delta
	move_and_collide(velocity)

func update_movement(delta):
	noise_coord += delta
	var cur_noise = noise_gen.get_noise_1d(noise_coord) * 100
	var noise_delta = clamp(cur_noise - prev_noise, -2.0, 2.0)
	prev_noise = cur_noise
	move_dir = move_dir.rotated(noise_delta * rotate_speed * delta)
	wall_avoidance()	
	look_at(global_position + move_dir)

func _process(delta):
	update_movement(delta)

func wall_avoidance() -> void:
	var close_walls = get_overlapping_walls()
	var avoid_vec : Vector2 = Vector2()
	for wall : Node2D in close_walls:
		avoid_vec += (global_position - wall.global_position).normalized()
	avoid_vec = avoid_vec.normalized()
	move_dir = (move_dir + avoid_vec * avoidance_fac * close_walls.size()).normalized()

func get_overlapping_walls() -> Array:
	var overlapped_bodies = overlap.get_overlapping_bodies()
	var overlapped_walls : Array
	for body : Node in overlapped_bodies:
		if body.is_in_group("Wall"):
			overlapped_walls.append(body)
	return overlapped_walls

func set_move_dir(new_dir) -> void:
	move_dir = new_dir
