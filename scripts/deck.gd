class_name Deck
extends ScrollContainer

const ITEM_SLOT: PackedScene = preload("res://scenes/item_slot.tscn")
const ITEMS_PATH: String = "res://resources/items"

@onready var inventory: Inventory = $Inventory

@export var x:int = 12
@export var y:int = 3

func _ready() -> void:
	_prepare_inventory_slots()
	_load_items_into_inventory()

func _prepare_inventory_slots() -> void:
	var slot_count: int = inventory.bg_grid_container.get_child_count()
	var missing_slots: int = slot_count - inventory.grid_container.get_child_count()
	for _i: int in range(missing_slots):
		inventory.grid_container.add_child(ITEM_SLOT.instantiate())

func _load_items_into_inventory() -> void:
	var item_resources: Array[ItemData] = _load_item_resources()
	if item_resources.is_empty():
		return

	var slots: Array[ItemSlot] = []
	for child: Node in inventory.grid_container.get_children():
		if child is ItemSlot:
			var slot: ItemSlot = child
			slot.item = null
			slot.is_drag_origin = false
			slot.update_ui()
			slots.append(slot)

	if slots.is_empty():
		return

	if inventory.grid_container.columns <= 0:
		inventory.grid_container.columns = x
	if inventory.bg_grid_container.columns <= 0:
		inventory.bg_grid_container.columns = inventory.grid_container.columns

	slots[0].refresh_grid_occupancy()
	for item_resource: ItemData in item_resources:
		var target_slot: ItemSlot = _find_slot_for_item(slots, item_resource)
		if target_slot == null:
			push_warning("Deck could not place item: %s" % item_resource.name)
			continue

		target_slot.item = item_resource
		target_slot.is_drag_origin = true
		target_slot.refresh_grid_occupancy()
		target_slot.update_ui()

func _load_item_resources() -> Array[ItemData]:
	var item_resources: Array[ItemData] = []
	var file_names: PackedStringArray = DirAccess.get_files_at(ITEMS_PATH)
	file_names.sort()

	for file_name: String in file_names:
		if not file_name.ends_with(".tres"):
			continue

		var resource: Resource = load("%s/%s" % [ITEMS_PATH, file_name])
		if resource is ItemData:
			item_resources.append(resource)

	return item_resources

func _find_slot_for_item(slots: Array[ItemSlot], item_resource: ItemData) -> ItemSlot:
	for slot: ItemSlot in slots:
		if slot.item != null:
			continue
		if slot._can_fit_item(item_resource):
			return slot
	return null
