extends Node
class_name StatesManager

var player : KinematicBody
var current_state = null

var idle_state : IdleState
var walk_state : WalkState
var sprint_state : SprintState
var crouch_state : CrouchState
var fall_state : FallState
var jump_state : JumpState
var mantle_state : MantleState

func init():
	idle_state = IdleState.new()
	idle_state.name = "IdleState"
	idle_state.connect("change_state", self, "change_state")
	add_child(idle_state)
	
	walk_state = WalkState.new()
	walk_state.name = "WalkState"
	walk_state.connect("change_state", self, "change_state")
	add_child(walk_state)
	
	sprint_state = SprintState.new()
	sprint_state.name = "SprintState"
	sprint_state.connect("change_state", self, "change_state")
	add_child(sprint_state)
	
	crouch_state = CrouchState.new()
	crouch_state.name = "CrouchState"
	crouch_state.connect("change_state", self, "change_state")
	add_child(crouch_state)
	
	fall_state = FallState.new()
	fall_state.name = "FallState"
	fall_state.connect("change_state", self, "change_state")
	add_child(fall_state)
	
	jump_state = JumpState.new()
	jump_state.name = "JumpState"
	jump_state.connect("change_state", self, "change_state")
	add_child(jump_state)
	
	mantle_state = MantleState.new()
	mantle_state.name = "MantleState"
	mantle_state.connect("change_state", self, "change_state")
	add_child(mantle_state)

func change_state(new_state):
	if(current_state != null):
		if(current_state == new_state):
			return
		get_state_object().call("_on_state_exit")
	
	current_state = new_state
	get_state_object().call("_on_state_enter")

func update_state(delta):
	get_state_object().call("_on_state_update", delta)
func physics_state(delta):
	get_state_object().call("_on_state_physics", delta)

func get_state_object():
	match current_state:
		GlobalDataBase.PLAYER_STATES.IDLE:
			return idle_state
		GlobalDataBase.PLAYER_STATES.WALK:
			return walk_state
		GlobalDataBase.PLAYER_STATES.SPRINT:
			return sprint_state
		GlobalDataBase.PLAYER_STATES.CROUCH:
			return crouch_state
		GlobalDataBase.PLAYER_STATES.FALL:
			return fall_state
		GlobalDataBase.PLAYER_STATES.JUMP:
			return jump_state
		GlobalDataBase.PLAYER_STATES.MANTLE:
			return mantle_state
	
	return null
