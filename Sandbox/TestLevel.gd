extends Spatial

# Called when the node enters the scene tree for the first time.
func _ready():
	OS.set_window_position(OS.get_screen_size(0)/2 - OS.get_window_size()/2)
