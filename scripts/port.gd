extends ScrollContainer

@onready var bg_grid_container: GridContainer = $MarginContainer/BGGridContainer
@onready var grid_container: GridContainer = $MarginContainer/GridContainer

const ITEM_SLOT: PackedScene = preload("res://scenes/item_slot.tscn")
var item_slot_instance: ItemSlot

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	init_inventory(3, 12)

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
