class_name ItemSlot
extends Panel

## The sprite display of the item stored in the slot.
## Note that the actual sprite must be accessed with [code]item_icon.texture[/code].
@onready var item_icon: TextureRect = $ItemIcon
## The actual item stored in the slot.
@export var item: ItemData
## Defines if the slot is a wall
## A wall cannot ever contain items
@export var is_wall: bool = false
## Defines if the slot is available or not.
## Must be set to false when slot is filled and true when emptied.
var is_empty: bool = true
## tells inspector if this panel has already been checked
var is_checked: bool = false
## slot containing an image's origin point
## only the origin point can display an item's image
var origin_point: bool = false

func _ready() -> void:
	if item:
		is_empty = false
	#print_debug("Node ", self, " holds texture ", item_icon.texture)
	update_ui()

func update_ui() -> void:
	if not origin_point or not item:
		item_icon.texture = null
		return
	
	item_icon.texture = item.sprite
	tooltip_text = item.name

func _get_drag_data(_at_position: Vector2) -> Variant:
	if not item:
		print_debug("Item slot ", self, " is empty") 
		return
		
	print_debug("Node ", self, " holds texture ", item_icon.texture)
	var item_preview: Panel = self.duplicate()
	var drag_preview: Control = Control.new()
	drag_preview.add_child(item_preview)
	item_preview.position -= Vector2(self.size.x, self.size.y)
	#item_preview.position -= Vector2(self.size.x / 2, self.size.y / 2)
	item_preview.self_modulate = Color.TRANSPARENT
	#drag_preview.scale = Vector2(0.75, 0.75)
	#drag_preview.modulate = Color(drag_preview.modulate, 0.75)
	
	set_drag_preview(drag_preview)
	item_icon.hide()
	origin_point = false
	is_empty = true
	return self

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	var thing: ItemSlot = data
	# check for every non-empty part of item's shape if it can go in its own slot
	return is_empty and not is_wall

func _drop_data(_at_position: Vector2, data: Variant) -> void:
	print_debug("Item slot ", self, " received ", data)
	var tmp: ItemData = item
	var safe_data: ItemSlot = data
	item = safe_data.item
	is_empty = false
	origin_point = true
	# CHANGE OTHER SLOTS AFTER THIS
	# ONLY THE SQUARE WHERE YOU HOLD THE ITEM SHOULD DISPLAY THE IMAGE
	safe_data.item = tmp
	item_icon.show()
	safe_data.item_icon.show()
	update_ui()
	safe_data.update_ui()
