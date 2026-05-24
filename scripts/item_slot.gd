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

## Initializes both the logical occupancy map and the visible icon state.
## This keeps the slot consistent whether it starts empty, contains an item,
## or is part of a larger grid-based inventory.
func _ready() -> void:
	refresh_grid_occupancy()
	update_ui()

## Synchronizes this slot's cached occupancy fields with its own local [code]item[/code].
## This path is mainly used when the slot is not inside a grid, so the slot
## simply mirrors its own item instead of participating in multi-cell logic.
func _sync_slot_state() -> void:
	occupying_item = item
	occupied_by = self if item != null else null
	is_empty = occupying_item == null

## Returns every [code]ItemSlot[/code] sibling in the parent grid.
## If this slot is not inside a [code]GridContainer[/code], it falls back to a
## single-slot array so the rest of the logic can use the same code path.
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

## Converts an item's 2D shape definition into offsets relative to the slot
## that acts as the item's origin.
## The bottom row of the shape becomes [code]y = 0[/code], which matches how
## items are anchored when dragged and placed in the inventory.
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

## Translates a shape offset into an absolute slot index inside the grid.
## Returns [code]-1[/code] when the shape would go out of bounds horizontally,
## vertically, or beyond the total slot count.
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

## Rebuilds occupancy information for every slot in the grid from scratch.
## This is the authoritative pass used after startup, after dragging begins,
## and after items are dropped, ensuring all covered cells know:
## - which origin slot owns them
## - which item is currently occupying them
## - whether they should be considered empty
func refresh_grid_occupancy() -> void:
	var slots: Array[ItemSlot] = _get_grid_slots()
	# Clear cached occupancy first so the grid can be recomputed cleanly.
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
		# Ignore empty slots and the item currently being dragged,
		# so the drag preview does not still block its original cells.
		if origin_slot.item == null or origin_slot.is_drag_origin:
			continue

		for offset: Vector2i in origin_slot._get_shape_offsets():
			var target_index: int = _get_slot_index_from_offset(origin_index, grid.columns, slots.size(), offset)
			if target_index == -1:
				# Invalid cells are skipped here;
				# placement validation is handled earlier by the fit checks.
				continue

			var target_slot: ItemSlot = slots[target_index]
			target_slot.occupied_by = origin_slot
			target_slot.occupying_item = origin_slot.item
			target_slot.is_empty = false

## Refreshes the visible sprite and tooltip so the panel reflects the current
## contents of the slot.
func update_ui() -> void:
	if not item:
		item_icon.texture = null
		item_icon.position = Vector2.ZERO
		tooltip_text = ""
		return

	item_icon.texture = item.sprite
	# The icon is shifted so multi-cell shapes line up visually with the slot
	# acting as the anchor/origin for placement.
	item_icon.position = item.get_shape_span()
	tooltip_text = item.name

## Calculates where the drag preview should be anchored relative to the mouse.
## The grab data comes from the item, allowing each shape to feel natural when
## picked up instead of always snapping from its top-left corner.
func _get_anchor() -> Vector2:
	var anchor_x: float = self.size.x * item.get_grab_data()[0]
	var anchor_y: float = self.size.x * item.get_grab_data()[1]
	var anchor: Vector2 = Vector2(anchor_x, anchor_y)
	return anchor

## Starts a drag operation for the current slot.
## A duplicate of the panel is used as the drag preview while the real icon is
## hidden, and the slot is marked as a temporary empty origin so placement
## checks can treat the moving item as lifted out of the grid.
func _get_drag_data(_at_position: Vector2) -> Variant: #TODO: Redirect drag attempts from 'occupied' slots to occupied_by node
	if not item and not occupied_by:
		#print_debug("Item slot ", self, " is empty")
		#print_debug("Drag attempt at ", _at_position)
		return

	if not item and occupied_by:
		print_debug("Slot %s belongs to %s (%s)" %[self, occupied_by, occupied_by.item.name])
		return
	

	#print_debug("Node ", self, " holds texture ", item_icon.texture)
	var item_preview: Panel = self.duplicate()
	var drag_preview: Control = Control.new()
	drag_preview.add_child(item_preview)
	# Offset the duplicated panel so the cursor grabs the item at its intended
	# anchor point rather than at the panel's own origin.
	item_preview.position -= _get_anchor()
	item_preview.self_modulate = Color.TRANSPARENT
	#drag_preview.scale = Vector2(0.75, 0.75)
	#drag_preview.modulate = Color(drag_preview.modulate, 0.75)

	set_drag_preview(drag_preview)
	item_icon.hide()
	is_drag_origin = true
	refresh_grid_occupancy()
	return self

## Checks whether [code]for_item[/code] can be placed with this slot as its origin.
## [code]ignored_origins[/code] lets drag-and-drop temporarily treat one or more
## already-occupied items as non-blocking, which is what makes swaps possible.
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
			# Any out-of-bounds cell means the whole placement is invalid.
			return false

		var target_slot: ItemSlot = slots[target_index]
		if target_slot.is_wall:
			return false
		# Occupied cells are only allowed if they belong to an origin ignored
		# for the purpose of this placement test.
		if target_slot.occupied_by != null and not ignored_origins.has(target_slot.occupied_by):
			return false

	return true

## Asks whether the dragged slot can be dropped here.
## The rules are:
## - walls reject all drops
## - dragging onto itself is invalid
## - empty targets only need to fit the incoming item
## - occupied targets must support a full swap,
##   meaning both items must fit once each other's occupied cells are temporarily ignored
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

## Completes the drop by swapping the two slot origins' items, restoring the
## dragged slot's visibility, then rebuilding both occupancy and UI state.
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
