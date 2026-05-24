class_name Inventory
extends Container

# preload cursor textures
@onready var grid_container: GridContainer = $GridContainer
@onready var bg_grid_container: GridContainer = $BGGridContainer
var drag_data: ItemSlot = null

const ITEM_SLOT: PackedScene = preload("res://scenes/item_slot.tscn")
var item_slot_instance: ItemSlot

#func _ready() -> void:
	#Input.set_custom_mouse_cursor(PRELOADED_TEXTURE, Input.CURSOR_TYPE)

func init_inventory(room_len: int, room_height: int) -> void:
	grid_container.columns = room_len
	bg_grid_container.columns = room_len
	for i: int in range(0, room_len):
		for j: int in range(0, room_height):
			item_slot_instance = ITEM_SLOT.instantiate()
			grid_container.add_child(item_slot_instance)
			
			var fake_slot: Panel = Panel.new()
			fake_slot.custom_minimum_size = Vector2(128, 128)
			bg_grid_container.add_child(fake_slot)

func _notification(what: int) -> void:
	if what == Node.NOTIFICATION_DRAG_BEGIN:
		#print_debug("Dragging started")
		drag_data = get_viewport().gui_get_drag_data()
	if what == Node.NOTIFICATION_DRAG_END:
		#print_debug("Dragging ended")
		if drag_data:
			drag_data.is_drag_origin = false
			drag_data.refresh_grid_occupancy()
			if not is_drag_successful():
				#print_debug("Dragging failed")
				drag_data.item_icon.show()
				drag_data.update_ui()
		if Inspection.inspection(Vector2(0,1), grid_container):
			print("FOUND CONTRABAND")
		drag_data = null
