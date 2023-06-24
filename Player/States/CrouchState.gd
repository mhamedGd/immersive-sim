extends BaseState
class_name CrouchState

func _on_state_enter() -> void:
	print(GlobalDataBase.PLAYER_STATES.keys()[get_state_enum()])
	root_player.standing_collider.disabled = true
	root_player.crouching_collider.disabled = false
	
	root_player.set_camera_height(crouchng_camera_height)

func _on_state_update(delta) -> void:
	if(!root_player.is_on_floor()):
		emit_signal("change_state", GlobalDataBase.PLAYER_STATES.FALL)
	if(Input.is_action_just_pressed("crouch")):
		emit_signal("change_state", GlobalDataBase.PLAYER_STATES.IDLE)

func _on_state_physics(delta) -> void:
	move(delta, max_crouch_speed)
	root_player.move_and_slide_with_snap(root_player.velocity, root_player.snap_vector, Vector3.UP)

func _on_state_exit() -> void:
	root_player.standing_collider.disabled = false
	root_player.crouching_collider.disabled = true
	
	root_player.set_camera_height(standing_camera_height)

func get_state_enum():
	return GlobalDataBase.PLAYER_STATES.CROUCH
