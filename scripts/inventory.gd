extends Panel

# preload cursor textures
@onready var grid_container: GridContainer = $GridContainer
var drag_data: ItemSlot = null

#func _ready() -> void:
	#Input.set_custom_mouse_cursor(PRELOADED_TEXTURE, Input.CURSOR_TYPE)

func _notification(what: int) -> void:
	if what == Node.NOTIFICATION_DRAG_BEGIN:
		#print_debug("Dragging started")
		drag_data = get_viewport().gui_get_drag_data()
	if what == Node.NOTIFICATION_DRAG_END:
		#print_debug("Dragging ended")
		#if Inspection.inspection(Vector2(0,1), grid_container):
			#print("FOUND CONTRABAND")
		if drag_data and not is_drag_successful():
			#print_debug("Dragging failed")
			drag_data.item_icon.show()
			drag_data.is_empty = drag_data.item == null
			drag_data.update_ui()
		drag_data = null
