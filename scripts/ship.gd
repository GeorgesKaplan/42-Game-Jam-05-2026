extends Control

@onready var cabin_inventory: Inventory = $CabinInventory
@onready var kitchen_inventory: Inventory = $KitchenInventory
@onready var cannons_inventory: Inventory = $CannonsInventory
@onready var cargo_inventory_up: Inventory = $CargoInventoryUp
@onready var cargo_inventory_down: Inventory = $CargoInventoryDown
@onready var toilets_inventory: Inventory = $ToiletsInventory
@onready var dormitory_inventory: Inventory = $DormitoryInventory


func _ready() -> void:
	cabin_inventory.init_inventory(13, 4)
	
	kitchen_inventory.init_inventory(10, 5)
	kitchen_inventory.resize_slots(115.0)
	
	cannons_inventory.init_inventory(15, 5)
	cannons_inventory.resize_slots(115.0)
	
	cargo_inventory_up.init_inventory(10, 3)
	
	cargo_inventory_down.init_inventory(6, 4)
	cargo_inventory_down.resize_slots(112.0)
	
	toilets_inventory.init_inventory(4, 4)
	
	dormitory_inventory.init_inventory(14, 5)
	dormitory_inventory.resize_slots(124)
