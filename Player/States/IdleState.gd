extends BaseState
class_name IdleState

func _on_state_enter() -> void:
	print(GlobalDataBase.PLAYER_STATES.keys()[get_state_enum()])
	root_player.set_camera_height(standing_camera_height)


func _on_state_update(delta) -> void:
	if(!root_player.is_on_floor()):
		emit_signal("change_state", GlobalDataBase.PLAYER_STATES.FALL)
	if(GlobalDataBase.input_vector.length_squared() != 0.0 and Input.is_action_pressed("sprint")):
		emit_signal("change_state", GlobalDataBase.PLAYER_STATES.SPRINT)
	elif GlobalDataBase.input_vector.length_squared() != 0.0:
		emit_signal("change_state", GlobalDataBase.PLAYER_STATES.WALK)
	if(Input.is_action_just_pressed("crouch")):
		emit_signal("change_state", GlobalDataBase.PLAYER_STATES.CROUCH)
	if(Input.is_action_just_pressed("jump")):
		if(check_mantle()):
			emit_signal("change_state", GlobalDataBase.PLAYER_STATES.MANTLE)
		else:
			emit_signal("change_state", GlobalDataBase.PLAYER_STATES.JUMP)

func _on_state_physics(delta) -> void:
	root_player.velocity.z = lerp(root_player.velocity.z, 0.0, delta * acceleration)
	root_player.velocity.x = lerp(root_player.velocity.x, 0.0, delta * acceleration)
	apply_gravity(delta)
	root_player.move_and_slide_with_snap(root_player.velocity, root_player.snap_vector, Vector3.UP)

func _on_state_exit() -> void:
	pass

func get_state_enum():
	return GlobalDataBase.PLAYER_STATES.IDLE
