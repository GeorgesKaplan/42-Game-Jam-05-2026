extends Panel

# preload cursor textures
var drag_data: ItemSlot = null
#func _ready() -> void:
	#Input.set_custom_mouse_cursor(PRELOADED_TEXTURE, Input.CURSOR_TYPE)

func _notification(what: int) -> void:
	if what == Node.NOTIFICATION_DRAG_BEGIN:
		#print_debug("Dragging started")
		drag_data = get_viewport().gui_get_drag_data()
	if what == Node.NOTIFICATION_DRAG_END:
		#print_debug("Dragging ended")
		if not is_drag_successful():
			#print_debug("Dragging failed")
			if drag_data:
				drag_data.item_icon.show()
				drag_data = null
