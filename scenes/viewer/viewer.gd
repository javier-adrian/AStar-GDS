extends Camera2D

var pan_mode := false
var mouse_offset: Vector2

func _input(event):
	if Input.is_action_just_released("zoom in") and not pan_mode:
		zoom *= 2

	if Input.is_action_just_released("zoom out") and not pan_mode:
		zoom /= 2

	if Input.is_action_just_pressed("pan"):
		pan_mode = true
		mouse_offset = get_global_mouse_position()

	if Input.is_action_just_released("pan"):
		pan_mode = false

	if pan_mode:
		position -= get_global_mouse_position() - mouse_offset