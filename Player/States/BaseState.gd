extends Spatial
class_name BaseState

signal change_state(new_state)

var root_player : KinematicBody

func _ready():
	root_player = get_parent().player


func _on_state_enter() -> void:
	pass

func _on_state_update(delta) -> void:
	pass

func _on_state_physics(delta) -> void:
	pass

func _on_state_exit() -> void:
	pass
	
func get_state_enum():
	return get_parent().PLAYER_STATES.IDLE


const max_speed = 4.0
const max_sprinting_speed = 8.0
const max_crouch_speed = 2.0
const acceleration = 4.0
const jump_height = 6.0
const gravity = 9.0

const standing_camera_height = 1.75
const crouchng_camera_height = 1.0

func apply_gravity(delta):
	if not root_player.is_on_floor():
		root_player.velocity.y -= gravity * delta
	else:
		root_player.velocity.y = 0.0

func move(delta, _speed):
	root_player.snap_vector = Vector3.DOWN
	var move_dir : Vector3 = GlobalDataBase.input_vector.normalized().rotated(Vector3.UP, root_player.rotation.y)
	
	apply_gravity(delta)
	
	if root_player.is_on_floor():
		root_player.snap_vector = -root_player.get_floor_normal()
	
	root_player.velocity.z = lerp(root_player.velocity.z, move_dir.z * _speed, delta * acceleration)
	root_player.velocity.x = lerp(root_player.velocity.x, move_dir.x * _speed, delta * acceleration)


const mantle_distance: float = 0.85
const ray_height: float = 1.0
const mantle_height: float = 1.5
const obstacle_in_depth: float = 0.025

func check_mantle() -> bool:
	var direct_state = get_world().direct_space_state
	var for_collision = direct_state.intersect_ray(root_player.global_transform.origin + Vector3.UP * ray_height, root_player.global_transform.origin + Vector3.UP * ray_height + root_player.global_transform.basis.z * mantle_distance, [root_player])
	
	if(for_collision):
		var down_collision = direct_state.intersect_ray(for_collision.position + root_player.global_transform.basis.z * obstacle_in_depth + Vector3.UP * mantle_height, for_collision.position + root_player.global_transform.basis.z * obstacle_in_depth, [root_player])
		if(down_collision):
			root_player.tracer.global_transform.origin  = down_collision.position
			root_player.mantle_pos = down_collision.position
			return true
	
	return false

