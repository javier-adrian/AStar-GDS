extends Camera2D

@onready var user_interface: CanvasLayer = $UserInterface
@onready var margins: MarginContainer = $UserInterface/Margins
@onready var start: CenterContainer = $UserInterface/Margins/HBoxContainer/Start
@onready var end: CenterContainer = $UserInterface/Margins/HBoxContainer/End

@onready var width: int = ProjectSettings.get_setting("display/window/size/viewport_width")
@onready var height: int = ProjectSettings.get_setting("display/window/size/viewport_height")

var pan_mode := false
var mouse_offset: Vector2

func toggle_start(setting: bool) -> void:
	start.visible = setting

func toggle_end(setting: bool) -> void:
	end.visible = setting

func _ready():
	margins.add_theme_constant_override("margin_top", height * .01)
	margins.add_theme_constant_override("margin_bottom", height * .01)
	margins.add_theme_constant_override("margin_left", width * .01)
	margins.add_theme_constant_override("margin_right", width * .01)

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
