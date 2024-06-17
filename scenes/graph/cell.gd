class_name Cell

var position: Vector2i

var f: int
var h: int
var g: int

var parent_cell: Cell
var successors: Array[Cell]


func distance_to(coords: Vector2i) -> int:
    return int(sqrt((position.x - coords.x)**2 + (position.y - coords.y)**2)*10)


func _init(coords: Vector2i, parent: Cell):
    position = coords
    parent_cell = parent