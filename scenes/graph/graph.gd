extends TileMap

const WALL = 0
const START = 1
const END = 2
const OPEN = 3
const CLOSED = 4
const CURRENT = 5

var wall: Array[Vector2i]
var start: Vector2i
var end: Vector2i

var found: bool
var start_is_ready: bool = false
var end_is_ready: bool = false

var open: Dictionary
var closed: Dictionary

var n: int

func reset_progress() -> void:
	open.clear()
	closed.clear()

	clear_layer(OPEN)
	clear_layer(CLOSED)
	clear_layer(CURRENT)

	found = false

func step() -> void:
	if found || !start_is_ready || !end_is_ready: return

	if open.is_empty():
		open[start] = Cell.new(start, null)

	search()
	

func replace_cell(layer: int, target: Vector2i, old: Vector2i) -> void:
	set_cell(layer, target, 0, Vector2i(0,0))
	erase_cell(layer, old)


func erase(target: Vector2i) -> void:
	match target:
		start:
			erase_cell(START, target)
			start = Vector2i.ZERO
			start_is_ready = false
		end:
			erase_cell(END, target)
			end = Vector2i.ZERO
			end_is_ready = false
		_:
			erase_cell(WALL, target)


func is_empty(target: Vector2i) -> bool:
	return !(wall.has(target) || target == start || target == end)


func add_wall(target: Vector2i) -> void:
	if is_empty(target):
		set_cell(WALL, target, 0, Vector2i(0,0))
		wall.append(target)


func place_start(target: Vector2i) -> void:
	if is_empty(target):
		replace_cell(START, target, start)
		start = target
		start_is_ready = true


func place_end(target: Vector2i) -> void:
	if is_empty(target):
		replace_cell(END, target, end)
		end = target
		end_is_ready = true


func search() -> void:
	var q: Cell
	var successors: Array[Cell]

	for cell in open:
		if (q && ((open[cell].f <= q.f) || (open[cell].h < q.h))) || !q:
			q = open[cell]
	
	open.erase(q.position)
	erase_cell(OPEN, q.position)

	clear_layer(CURRENT)
	set_cell(CURRENT, q.position, 0, Vector2i(0,0))
 
	for x in range(q.position.x - 1, q.position.x + 2):
		for y in range(q.position.y - 1, q.position.y + 2):
			if !(x == q.position.x && y == q.position.y):
				successors.append(Cell.new(Vector2i(x,y), q))
	
	for successor in successors:
		if successor.position == end:
			found = true
			continue
		if successor.position == start || successor.position in get_used_cells(WALL):
			continue
		else:
			successor.g = q.g + successor.distance_to(q.position)
			successor.h = successor.distance_to(end)
			successor.f = successor.g + successor.h

			if open.has(successor.position):
				if open[successor.position].f < successor.f:
					continue
			if closed.has(successor.position):
				if closed[successor.position].f < successor.f:
					continue
			else:
				open[successor.position] = successor
				set_cell(OPEN, successor.position, 0, Vector2i(0, 0))
		
	if q.position != start && q.position != end:
		closed[q.position] = q
		set_cell(CLOSED, q.position, 0, Vector2i(0, 0))
