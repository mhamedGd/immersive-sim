extends BaseState
class_name MantleState

var up_position : Vector3
var for_position : Vector3

func _on_state_enter() -> void:
	print(GlobalDataBase.PLAYER_STATES.keys()[get_state_enum()])
	root_player.velocity = Vector3.ZERO
	
	up_position = root_player.global_transform.origin + Vector3.UP * (abs(root_player.mantle_pos.y - root_player.global_transform.origin.y) + 0.05)
	for_position = up_position + root_player.global_transform.basis.z * 1.25
	current_target = up_position

var current_target:Vector3
func _on_state_update(delta) -> void:
	root_player.global_transform.origin = lerp(root_player.global_transform.origin, current_target, 0.1)
	if(root_player.global_transform.origin.distance_to(up_position) < 0.05):
		current_target = for_position
	if(root_player.global_transform.origin.distance_to(for_position) < 0.05):
		emit_signal("change_state", GlobalDataBase.PLAYER_STATES.IDLE)

func _on_state_physics(delta) -> void:
	pass

func _on_state_exit() -> void:
	pass

func get_state_enum():
	return GlobalDataBase.PLAYER_STATES.MANTLE
