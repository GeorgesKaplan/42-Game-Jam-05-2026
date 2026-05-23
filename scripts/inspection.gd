extends Node

var room: Array[Node]

func floodfill(start: Vector2, columns: int) -> int:
	if room[start.y * columns + start.x]:
		return 1
	var fail :int = 0
	
	return fail

#returns false if contraband is found and true otherwise
func inspection(start: Vector2, piece: GridContainer) -> bool:
	room = piece.get_children()
	if floodfill(start, piece.columns) >= 0:
		return false
	return true
