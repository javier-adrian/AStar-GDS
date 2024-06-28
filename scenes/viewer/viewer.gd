extends Camera2D

@onready var user_interface: CanvasLayer = $UserInterface
# @onready var margins: MarginContainer = $UserInterface/Margins
@onready var start: CenterContainer = $UserInterface/TopLeft/HBoxContainer/Start
@onready var end: CenterContainer = $UserInterface/TopLeft/HBoxContainer/End
@onready var found: CenterContainer = $UserInterface/TopLeft/HBoxContainer/Found
@onready var coordinates: Label = $UserInterface/BottomLeft/VBoxContainer/Coords

@onready var width: int = ProjectSettings.get_setting("display/window/size/viewport_width")
@onready var height: int = ProjectSettings.get_setting("display/window/size/viewport_height")

var pan_mode := false
var mouse_offset: Vector2

func toggle_start(setting: bool) -> void:
	start.visible = setting

func toggle_end(setting: bool) -> void:
	end.visible = setting

func toggle_found(setting: bool) -> void:
	found.visible = setting

func update_coords(coords: Vector2i) -> void:
	coordinates.text = "{0}, {1}".format([coords.x, coords.y])

func _ready():
	for node in user_interface.get_children():
		node.add_theme_constant_override("margin_top", height * .01)
		node.add_theme_constant_override("margin_bottom", height * .01)
		node.add_theme_constant_override("margin_left", width * .01)
		node.add_theme_constant_override("margin_right", width * .01)

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
