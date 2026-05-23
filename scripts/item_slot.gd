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

func _ready() -> void:
	_sync_slot_state()
	update_ui()

func _sync_slot_state() -> void:
	is_empty = item == null

func update_ui() -> void:
	if not item:
		item_icon.texture = null
		tooltip_text = ""
		return

	item_icon.texture = item.sprite
	tooltip_text = item.name

func _get_anchor() -> Vector2:
	var anchor_x: float = self.size.x * item.get_grab_data()[0]
	var anchor_y: float = self.size.x * item.get_grab_data()[1]
	var anchor: Vector2 = Vector2(anchor_x, anchor_y)
	return anchor

func _get_drag_data(_at_position: Vector2) -> Variant:
	if not item:
		#print_debug("Item slot ", self, " is empty")
		return

	#print_debug("Node ", self, " holds texture ", item_icon.texture)
	var item_preview: Panel = self.duplicate()
	var drag_preview: Control = Control.new()
	drag_preview.add_child(item_preview)
	item_preview.position -= _get_anchor()
	item_preview.self_modulate = Color.TRANSPARENT
	#drag_preview.scale = Vector2(0.75, 0.75)
	#drag_preview.modulate = Color(drag_preview.modulate, 0.75)

	set_drag_preview(drag_preview)
	item_icon.hide()
	is_empty = true
	return self

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	if is_wall or data == self or not data is ItemSlot:
		return false

	var source_slot: ItemSlot = data
	return source_slot.item != null

func _drop_data(_at_position: Vector2, data: Variant) -> void:
	#print_debug("Item slot ", self, " received ", data)
	var tmp: ItemData = item
	var safe_data: ItemSlot = data
	item = safe_data.item
	safe_data.item = tmp
	_sync_slot_state()
	safe_data._sync_slot_state()
	item_icon.show()
	safe_data.item_icon.show()
	update_ui()
	safe_data.update_ui()
