extends Node2D

@onready var graph := $Graph
@onready var tile_size: Vector2 = Vector2(graph.tile_set.tile_size)

var target: Vector2


func _input(event):
    target = floor(get_global_mouse_position() / tile_size)
    
    if Input.is_action_pressed("wall"):
        graph.add_wall(target)

    if Input.is_action_pressed("erase"):
        graph.erase(target)

    if Input.is_action_just_released("start"):
        graph.place_start(target)

    if Input.is_action_just_released("end"):
        graph.place_end(target)

    if Input.is_action_pressed("step"):
        graph.step()

    if Input.is_action_pressed("erase"):
        graph.erase(target)