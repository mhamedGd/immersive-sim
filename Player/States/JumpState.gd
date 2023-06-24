extends BaseState
class_name JumpState

func _on_state_enter() -> void:
	print(GlobalDataBase.PLAYER_STATES.keys()[get_state_enum()])
	root_player.velocity.y += jump_height
	root_player.move_and_slide(root_player.velocity, Vector3.UP)

func _on_state_update(delta) -> void:
	if(root_player.velocity.y < -0.05):
		emit_signal("change_state", GlobalDataBase.PLAYER_STATES.FALL)
	if(Input.is_action_just_pressed("jump") and check_mantle()):
		emit_signal("change_state", GlobalDataBase.PLAYER_STATES.MANTLE)

func _on_state_physics(delta) -> void:
	apply_gravity(delta)
	root_player.move_and_slide(root_player.velocity, Vector3.UP)

func _on_state_exit() -> void:
	pass

func get_state_enum():
	return GlobalDataBase.PLAYER_STATES.JUMP
