extends ScrollContainer

@onready var inventory: Inventory = $Inventory
const Loading: Resource = preload("uid://bsdh43ptepor8")

@export var x:int = 12
@export var y:int = 3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print_debug("WENT HERE")
	var line:Array = inventory.grid_container.get_children()
	for i:ItemSlot in line:
		i.update_ui()
	#inventory.init_inventory(x, y)
	#load_cargo()#Loading.get_cargo()

#func bruteforce_item(thingy:ItemData, place:ItemSlot) -> void:
	#place.item = thingy
	#place.is_drag_origin = true
	##breakpoint
	#place.update_ui()

#func load_cargo()->void: #cargo:Array[ItemData]) -> void:
	#var line:Array = inventory.grid_container.get_children()
	
	## TEST
	#bruteforce_item(Loading.content[0], line[0])
	#bruteforce_item(Loading.content[1], line[24])
	#bruteforce_item(Loading.content[2], line[27])
	#bruteforce_item(Loading.content[3], line[29])
	#bruteforce_item(Loading.content[4], line[30])
	## END TEST
	
	#var posX:int = 0
	#for i:ItemData in cargo:
		#line[((i.origin / 3) * y) + posX + (i.origin % 3)] = i
		#
		#match i.shape:
			#ItemData.Shape.SINGLE or ItemData.Shape.TALL or ItemData.Shape.VTALL:
				#posX += 1
			#ItemData.Shape.LONG or ItemData.Shape.SQUARE or ItemData.Shape.LVTALL:
				#posX += 2
			#_:
				#posX += 3
