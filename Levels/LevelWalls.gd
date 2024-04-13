extends Node2D

@export var level_width : float
@export var level_height : float
@export var wall_scene : PackedScene

func build_level():
	var wall_length = 64
	var wall_height = 16
	var width_wall_num = roundi(level_width / wall_length)
	var top_left_start : Vector2 = Vector2(-level_width/2, -level_height/2)
	var bot_right_start = -top_left_start
	var height_wall_num = roundi(level_height / wall_length)
	
	# top and bottom walls
	for i in  width_wall_num:
		var top_pos = top_left_start + Vector2(wall_length / 2  + i * wall_length, wall_height / 2)
		var bot_pos = bot_right_start - Vector2(wall_length / 2 + i * wall_length, wall_height / 2)
		$Top.add_child(create_wall_at_pos(top_pos))
		$Bottom.add_child(create_wall_at_pos(bot_pos))
		
	# left and right walls
	for i in  height_wall_num:
		var left_post = top_left_start + Vector2(wall_height / 2, wall_length / 2 + i * wall_length)
		var right_pos = bot_right_start - Vector2(wall_height / 2, wall_length / 2 + i * wall_length)
		$Left.add_child(create_wall_at_pos(left_post, true))
		$Right.add_child(create_wall_at_pos(right_pos, true))

func create_wall_at_pos(pos : Vector2, rotated = false) -> StaticBody2D:
	var new_wall = wall_scene.instantiate() as StaticBody2D
	new_wall.global_position = pos
	if rotated:
		new_wall.global_rotation_degrees = 90
	return new_wall

func _ready():
	build_level()
