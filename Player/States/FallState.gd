extends BaseState
class_name FallState

func _on_state_enter() -> void:
	print(GlobalDataBase.PLAYER_STATES.keys()[get_state_enum()])

var falling_time : float = 0.0
var initial_air_height : float = 0.0
var end_air_height : float = 0.0

func _on_state_update(delta) -> void:
	if(root_player.is_on_floor()):
		emit_signal("change_state", GlobalDataBase.PLAYER_STATES.IDLE)
	if(Input.is_action_just_pressed("jump") and check_mantle()):
		emit_signal("change_state", GlobalDataBase.PLAYER_STATES.MANTLE)
	
	falling_time += delta

func _on_state_physics(delta) -> void:
	
	apply_gravity(delta)
	root_player.move_and_slide(root_player.velocity, Vector3.UP)

func _on_state_exit() -> void:
	end_air_height = root_player.global_transform.origin.y
	root_player.camera.apply_impulse(Vector3.DOWN * falling_time * 0.17)
	falling_time = 0.0

func get_state_enum():
	return GlobalDataBase.PLAYER_STATES.FALL
