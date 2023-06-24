extends Camera


export (float) var tension = 0.5
export (float) var dampening = 0.1

var resting_position := Vector3.ZERO
var spring_position := Vector3.ZERO
var spring_velocity := Vector3.ZERO

func apply_impulse(_impulse: Vector3):
	spring_velocity += _impulse

func _process(delta):
	translation = spring_process(delta)


func spring_process(delta:float) -> Vector3:
	var displacement:= (resting_position - spring_position) * delta
	spring_velocity += (displacement * tension) - (spring_velocity * dampening)
	spring_position += spring_velocity
	return spring_position
