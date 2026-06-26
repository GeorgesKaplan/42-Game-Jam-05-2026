extends Node

var room: Array[ItemSlot]
var Rlen: int
var Rhgt: int

#returns a positive interger if an illegal item is found via the x & y starting point
func floodfill(x: int, y: int) -> int:
	print("{x = %s} {y = %s} {Rlen = %s} {Rhgt = %s} {room.size = %s}" %[x, y, Rlen, Rhgt, room.size()])
	var slot: ItemSlot = room[y * Rlen + x]
	#sets current case as checked to avoid checking it again
	slot.is_checked = true
	#checks if slot is full, if so, if it is taken by an illegal item
	if not slot.is_empty:
		if slot.occupying_item != null and slot.occupying_item.illegal:
			return 1
		return 0

	var fail: int = 0

	if y >= 0 and not room[(y - 1) * Rlen + x].is_checked:		#check up
		fail += floodfill(x, y - 1)
	if y < Rhgt - 1 and not room[(y + 1) * Rlen + x].is_checked:	#check down
		fail += floodfill(x, y + 1)
	if x >= 0 and not room[y * Rlen + (x - 1)].is_checked:			#check left
		fail += floodfill(x - 1, y)
	if x < Rlen - 1 and not room[y * Rlen + (x + 1)].is_checked:	#check right
		fail += floodfill(x + 1, y)
	return fail

#returns true if contraband is found and false otherwise
func inspection(start: Vector2, piece: GridContainer) -> bool:
	room.clear()
	#creating a copy of the room so that original data of room won't change (line 16)
	var tmp: Array[Node] = piece.get_children()
	for n: Node in tmp:
		if n is ItemSlot:
			room.append(n)
			@warning_ignore("unsafe_property_access")
			n.is_checked = false
			@warning_ignore("unsafe_property_access")
			if n.is_wall:
				@warning_ignore("unsafe_property_access")
				n.is_checked = true

	Rlen = piece.columns
	@warning_ignore("integer_division")
	Rhgt = room.size() / Rlen

	#doing actual floodfill
	if floodfill(int(start.x), int(start.y)) == 0:
		room.clear()
		return false
	room.clear()
	return true


#func end_of_level(ship:Array[GridContainer]) -> void:
	#for i in ship:
		#inspection(Vector2(0,2), ship[i])
