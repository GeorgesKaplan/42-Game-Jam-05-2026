extends ScrollContainer

# basically another inventory space
@onready var inventory: Inventory = $Inventory
var drag_data: ItemSlot = null

func _ready() -> void:
	inventory.init_inventory(3, 5)
	var actual_container: GridContainer = self.get_node("Inventory").get_node("GridContainer")
	actual_container.columns = 3
	

#func _notification(what: int) -> void:
	#if what == Node.NOTIFICATION_DRAG_BEGIN:
		##print_debug("Dragging started")
		#drag_data = get_viewport().gui_get_drag_data()
	#if what == Node.NOTIFICATION_DRAG_END:
		##print_debug("Dragging ended")
		#if drag_data:
			#drag_data.is_drag_origin = false
			#drag_data.refresh_grid_occupancy()
			#if not is_drag_successful():
				##print_debug("Dragging failed")
				#drag_data.item_icon.show()
				#drag_data.update_ui()
		#drag_data = null
