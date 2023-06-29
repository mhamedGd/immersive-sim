extends Camera


export (float) var tension = 0.6
export (float) var dampening = 0.15

var resting_position := Vector3.ZERO
var spring_position := Vector3.ZERO
var spring_velocity := Vector3.ZERO

func apply_impulse(_impulse: Vector3):
	spring_velocity += _impulse

func _process(delta):
	translation = spring_process(delta)

func set_camera_resting_pos(new_resting_pos):
	resting_position = new_resting_pos

func spring_process(delta:float) -> Vector3:
	var displacement:= (resting_position - spring_position) * delta
	spring_velocity += (displacement * tension) - (spring_velocity * dampening)
	spring_position += spring_velocity
	return spring_position
