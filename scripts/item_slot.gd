class_name ItemSlot
extends Panel

## The sprite display of the item stored in the slot.
## Note that the actual sprite must be accessed with [code]item_icon.texture[/code].
#@onready var item_icon: TextureRect = $ItemIcon
@onready var item_icon: Sprite2D = $ItemIcon
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
## The origin slot of the item currently covering this cell.
var occupied_by: ItemSlot = null
## The item currently covering this cell, whether this slot is the origin or not.
var occupying_item: ItemData = null
## Marks the origin slot temporarily ignored while its item is being dragged.
var is_drag_origin: bool = false

func _ready() -> void:
	refresh_grid_occupancy()
	update_ui()

func _sync_slot_state() -> void:
	occupying_item = item
	occupied_by = self if item != null else null
	is_empty = occupying_item == null

func _get_grid_slots() -> Array[ItemSlot]:
	var grid: GridContainer = get_parent() as GridContainer
	var slots: Array[ItemSlot] = []
	if grid == null:
		slots.append(self)
		return slots

	for child: Node in grid.get_children():
		if child is ItemSlot:
			slots.append(child)
	return slots

func _get_shape_offsets(for_item: ItemData = null) -> Array[Vector2i]:
	var offsets: Array[Vector2i] = []
	if for_item == null:
		for_item = item
	if for_item == null:
		return offsets

	var shape_data: Array = for_item.get_shape_data()
	var bottom_row: int = shape_data.size() - 1
	for row: int in range(shape_data.size()):
		var row_data: Array = shape_data[row]
		for column: int in range(row_data.size()):
			@warning_ignore("unsafe_call_argument")
			if int(row_data[column]) == 1:
				offsets.append(Vector2i(column, row - bottom_row))
	return offsets

func _get_slot_index_from_offset(base_index: int, columns: int, slot_count: int, offset: Vector2i) -> int:
	@warning_ignore("integer_division")
	var base_row: int = base_index / columns
	var base_column: int = base_index % columns
	var target_row: int = base_row + offset.y
	var target_column: int = base_column + offset.x

	if target_row < 0 or target_column < 0 or target_column >= columns:
		return -1

	var target_index: int = target_row * columns + target_column
	if target_index < 0 or target_index >= slot_count:
		return -1

	return target_index

func refresh_grid_occupancy() -> void:
	var slots: Array[ItemSlot] = _get_grid_slots()
	for slot: ItemSlot in slots:
		slot.occupied_by = null
		slot.occupying_item = null
		slot.is_empty = true

	var grid: GridContainer = get_parent() as GridContainer
	if grid == null:
		_sync_slot_state()
		return

	for origin_index: int in range(slots.size()):
		var origin_slot: ItemSlot = slots[origin_index]
		if origin_slot.item == null or origin_slot.is_drag_origin:
			continue

		for offset: Vector2i in origin_slot._get_shape_offsets():
			var target_index: int = _get_slot_index_from_offset(origin_index, grid.columns, slots.size(), offset)
			if target_index == -1:
				continue

			var target_slot: ItemSlot = slots[target_index]
			target_slot.occupied_by = origin_slot
			target_slot.occupying_item = origin_slot.item
			target_slot.is_empty = false

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
	is_drag_origin = true
	refresh_grid_occupancy()
	return self

func _can_fit_item(for_item: ItemData, ignored_origins: Array[ItemSlot] = []) -> bool:
	var grid: GridContainer = get_parent() as GridContainer
	if grid == null:
		return for_item != null and not is_wall

	var slots: Array[ItemSlot] = _get_grid_slots()
	var origin_index: int = slots.find(self)
	if origin_index == -1 or for_item == null:
		return false

	for offset: Vector2i in _get_shape_offsets(for_item):
		var target_index: int = _get_slot_index_from_offset(origin_index, grid.columns, slots.size(), offset)
		if target_index == -1:
			return false

		var target_slot: ItemSlot = slots[target_index]
		if target_slot.is_wall:
			return false
		if target_slot.occupied_by != null and not ignored_origins.has(target_slot.occupied_by):
			return false

	return true

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	if is_wall or data == self or not data is ItemSlot:
		return false

	var source_slot: ItemSlot = data
	if source_slot.item == null:
		return false

	var ignored_origins: Array[ItemSlot] = [source_slot]
	if item == null:
		return _can_fit_item(source_slot.item, ignored_origins)

	ignored_origins.append(self)
	return _can_fit_item(source_slot.item, ignored_origins) and source_slot._can_fit_item(item, ignored_origins)

func _drop_data(_at_position: Vector2, data: Variant) -> void:
	#print_debug("Item slot ", self, " received ", data)
	var tmp: ItemData = item
	var safe_data: ItemSlot = data
	item = safe_data.item
	safe_data.item = tmp
	safe_data.is_drag_origin = false
	item_icon.show()
	safe_data.item_icon.show()
	refresh_grid_occupancy()
	update_ui()
	safe_data.update_ui()
