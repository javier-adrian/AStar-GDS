extends Node2D

@onready var graph := $Graph
@onready var timer := $Timer
@onready var viewer := $Viewer
@onready var tile_size: Vector2 = Vector2(graph.tile_set.tile_size)

var target: Vector2
var playing := false


func _input(event):
    target = floor(get_global_mouse_position() / tile_size)
    
    if Input.is_action_pressed("wall"):
        graph.add_wall(target)

    if Input.is_action_pressed("erase"):
        graph.erase(target)

    if Input.is_action_just_released("start"):
        graph.place_start(target)
        viewer.toggle_start(true)

    if Input.is_action_just_released("end"):
        graph.place_end(target)
        viewer.toggle_end(true)

    if Input.is_action_pressed("step"):
        graph.step()

    if Input.is_action_pressed("erase"):
        graph.erase(target)
        viewer.toggle_start(graph.start_is_ready)
        viewer.toggle_end(graph.end_is_ready)

    if Input.is_action_pressed("play"):
        playing = !playing
        timer.start()

    if Input.is_action_pressed("reset_progress"):
        graph.reset_progress()
        playing = false
        viewer.toggle_found(false)

    if Input.is_action_pressed("reset"):
        graph.reset()
        playing = false
        viewer.toggle_start(false)
        viewer.toggle_end(false)
        viewer.toggle_found(false)

func _on_timer_timeout():
    if playing:
        graph.step()
        timer.start()


func _on_graph__found():
    viewer.toggle_found(true)
