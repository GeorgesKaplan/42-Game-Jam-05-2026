extends Control

@onready var inventory: Inventory = $Inventory

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	inventory.init_inventory(14, 4)
