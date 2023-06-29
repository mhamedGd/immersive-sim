extends KinematicBody

onready var camera = $CameraContainer/Camera
onready var camera_container = $CameraContainer

var states_manager : StatesManager

onready var standing_collider   = $StandingCollision
onready var crouching_collider  = $CrouchingCollision
onready var ducking_collider    = $StandingCollision
var current_camera_height : float = 1.6

onready var tracer = $Tracer

var snap_vector : Vector3
var velocity : Vector3
var mantle_pos: Vector3
var down_ray_pos: Vector3

export (float) var camera_pos_rot_z = -25.0

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	states_manager = StatesManager.new()
	states_manager.name = "StatesManager"
	states_manager.player = self
	states_manager.init()
	add_child(states_manager)
	
	states_manager.change_state(GlobalDataBase.PLAYER_STATES.IDLE)

func _process(delta):
	GlobalDataBase.input_vector.x = Input.get_action_strength("left") - Input.get_action_strength("right")
	GlobalDataBase.input_vector.z = Input.get_action_strength("forward") - Input.get_action_strength("backward")
	
	states_manager.update_state(delta)
	change_camera_height()
	update_camera_rot_z()

func _physics_process(delta):
	states_manager.physics_state(delta)

func _input(event):
	if(event is InputEventMouseMotion):
		look_around(event)

var look_rotation : Vector2 = Vector2.ZERO
export (float) var mouse_sensitivity = 0.1
export (float) var min_x_rotation = -80.0
export (float) var max_x_rotation = 90.0
func look_around(event):
	look_rotation.x = camera_container.rotation_degrees.x
	look_rotation.y = rotation_degrees.y
	
	look_rotation.x += event.relative.y * mouse_sensitivity
	look_rotation.y -= event.relative.x * mouse_sensitivity
	look_rotation.x = clamp(look_rotation.x, min_x_rotation, max_x_rotation)
	
	camera_container.rotation_degrees.x = look_rotation.x
	rotation_degrees.y = look_rotation.y

var curr_frame_camera_height:float = 0.0
var prev_frame_camera_height:float = 0.0
func change_camera_height():
	var new_camera_container_locpos = camera_container.translation
	new_camera_container_locpos.y = current_camera_height
	camera_container.translation = lerp(camera_container.translation, new_camera_container_locpos, 0.1)

func set_camera_height(new_height):
	current_camera_height = new_height
	
func update_camera_rot_z():
	var lean_str = Input.get_action_strength("lean_right") - Input.get_action_strength("lean_left")
	var cam_rot = camera.rotation_degrees
	cam_rot.z = camera_pos_rot_z * lean_str
	camera.rotation_degrees = lerp(camera.rotation_degrees, cam_rot, 0.1)
	camera.set_camera_resting_pos(Vector3.RIGHT * 0.5 * -lean_str)
