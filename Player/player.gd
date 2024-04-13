extends Node2D

@export var herd_radius : float

@onready var herd_area : Area2D = $OverlapArea

func _ready():
	herd_area.get_node("CollisionShape2D").shape.radius = herd_radius
	herd_area.get_node("Sprite2D").global_scale = Vector2.ONE * herd_radius / 32.0

func default_herd():
	herd_area.visible = true
	var herded = herd_area.get_overlapping_bodies()
	for unit : Node in herded:
		if unit.is_in_group("Unit"):
			unit.set_move_dir((unit.global_position - herd_area.global_position).normalized())
	
func _process(delta):
	herd_area.global_position = get_global_mouse_position()	
	if Input.is_action_just_pressed("herd"):
		default_herd()
