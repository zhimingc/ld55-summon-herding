extends Unit

@export var summie_scene : PackedScene

# summoning vars
@export var summon_rate : Vector2
@export var summon_range : Vector2
var summon_timer : float

func _ready():
	init_movement()
	reset_summoning()
	
func _physics_process(delta):
	velocity = move_dir * move_speed * delta
	move_and_collide(velocity)

func _process(delta):
	update_movement(delta)
	update_summoning(delta)

func reset_summoning() -> void:
	summon_timer = randf_range(summon_rate.x, summon_rate.y)	

func update_summoning(delta) -> void:
	summon_timer -= delta
	if summon_timer <= 0.0:
		summon()
		reset_summoning()
	pass

func summon() -> void:
	var new_summie = summie_scene.instantiate() as Node2D
	new_summie.global_position = get_summon_pos()
	new_summie.modulate = modulate
	get_tree().root.add_child(new_summie)
	pass
	
func get_summon_pos() -> Vector2:
	var summon_dist = randf_range(summon_range.x, summon_range.y)
	var summon_pos = global_position + Vector2.ONE.rotated(randf() * 6.2).normalized() * summon_dist
	return summon_pos
	
